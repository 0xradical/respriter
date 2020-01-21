require 'dnsruby'
require 'syslogger'

module Developers
  class DomainAuthorityVerificationJob < Que::Job
    class Error < StandardError; end
    SERVICE_NAME = 'domain-validation-service'

    self.priority = 100

    attr_reader :logger

    def initialize(*)
      super

      @logger = SysLogger.new
    end

    def run(id, user_id)
      log(id, 'Started domain verification')

      crawler_domain = CrawlerDomain.find_by(id: id)
      if crawler_domain.nil?
        raise '#100000: Domain structure not found on database'
      end

      user_account = UserAccount.find_by(id: user_id)
      if user_account.nil?
        raise "#100001: Domain's associated user not found on database"
      end

      if crawler_domain.authority_confirmation_status == 'confirmed'
        raise '#100002: Domain already validated'
      end

      if crawler_domain.authority_confirmation_status == 'unconfirmed'
        crawler_domain.update(authority_confirmation_status: 'confirming')
      end

      resolver = Dnsruby::DNS.new

      authority_confirmed_via_dns = false
      authority_confirmed_via_html = false

      # DNS by TXT entry
      begin
        log(id, 'Verifying TXT DNS entries')
        resolver.each_resource(crawler_domain.domain, 'TXT') do |rr|
          if rr.data == crawler_domain.authority_txt
            authority_confirmed_via_dns = true
            break
          end
        end
      rescue Exception => e
        log(id, 'Could not verify via TXT DNS entries')
        nil
      end

      if !authority_confirmed_via_dns
        # DNS by CNAME entry
        log(id, 'Could not verify via TXT DNS entries, trying CNAME entries')
        begin
          resolver.each_resource(
            crawler_domain.authority_cname,
            'CNAME'
          ) do |rr|
            if rr.rdata.to_s == 'verification.classpert.com'
              authority_confirmed_via_dns = true
              break
            end
          end
        rescue Exception => e
          log(id, 'Could not verify via CNAME DNS entries')
        end
      end

      if authority_confirmed_via_dns
        confirm!(user_id, crawler_domain, 'dns')
        log(id, 'Successfully verified domain via DNS')
      else
        log(id, 'Could not verify via CNAME DNS entries, trying HTML method')
        # try via HTML
        crawler_domain.possible_uris.each do |u|
          break if authority_confirmed_via_html

          begin
            response = Net::HTTP.get_response(URI.parse(u.to_s))

            if response.code == '200'
              document = Nokogiri.HTML(response.body)

              document.css('meta').each do |meta|
                if meta.attributes['name']&.value ==
                     CrawlerDomain::DOMAIN_VERIFICATION_KEY &&
                     meta.attributes['content']&.value ==
                       crawler_domain.authority_confirmation_token
                  authority_confirmed_via_html = true
                  break
                end
              end
            end
          rescue StandardError
            false
          end
        end

        if authority_confirmed_via_html
          confirm!(user_id, crawler_domain, 'html')
          log(id, 'Successfully verified domain via HTML')
        else
          if error_count < 10
            crawler_domain.update(authority_confirmation_status: 'unconfirmed')
            log(id, '#100004: Domain validation failed temporarily', :error)

            raise DomainAuthorityVerificationJob::Error
          else
            CrawlerDomain.transaction do
              crawler_domain.update(authority_confirmation_status: 'failed')
              expire
            end

            log(id, '#100005: Domain validation failed permanently', :error)
          end
        end
      end
    rescue StandardError => e
      if crawler_domain
        CrawlerDomain.transaction do
          crawler_domain.update(authority_confirmation_status: 'failed')
          expire
        end
      else
        expire
      end

      log(id, e.message, :error)
    end

    def confirm!(user_id, crawler_domain, confirmation_method)
      provider = nil
      provider_crawler = nil
      provider_name = nil

      log(crawler_domain.id, 'Deriving name from domain')

      begin
        parsed_domain = PublicSuffix.parse(crawler_domain.domain)

        provider_name =
          [parsed_domain.sld, parsed_domain.trd].compact.map do |domain_part|
            domain_part.split(/\./).map do |part|
              part.gsub(/\-/, '_').gsub(/[^A-Za-z0-9_]/, '').camelcase
            end.join(' ')
          end.select { |name| Provider.where(name: name).count == 0 }.first
      rescue StandardError
        raise '#100006: Name derived from domain url cannot be used'
      end

      if provider_name
        log(crawler_domain.id, 'Successfully derived name from domain')
      else
        raise '#100007: Name derivation from domain failed'
      end

      ApplicationRecord.transaction do
        provider = Provider.create(name: provider_name)

        provider_crawler =
          ProviderCrawler.create(
            { provider_id: provider.id, user_account_ids: [user_id] }
          )

        crawler_domain.update(
          {
            authority_confirmation_method: confirmation_method,
            authority_confirmation_token:
              crawler_domain.authority_confirmation_token,
            authority_confirmation_salt: ENV['DOMAIN_VERIFICATION_SALT'],
            provider_crawler_id: provider_crawler.id
          }
        )
      end

      if provider && provider_crawler
        detect_sitemap(crawler_domain, provider_crawler)
        setup_provider_crawler(crawler_domain, provider_crawler)
      else
        raise 'Database error'
      end

      crawler_domain.update(authority_confirmation_status: 'confirmed')
    rescue StandardError
      raise 'Confirmation failed, trying again'
    end

    def detect_sitemap(crawler_domain, provider_crawler)
      log(crawler_domain.id, 'Trying to detect sitemap automatically')

      robot_method =
        proc do |uri|
          robots_parser = Robotstxt.get(uri, 'Classpert Bot')
          robots_parser.sitemaps.first.presence
        end
      sitemap_xml_method =
        proc do |uri|
          response = Net::HTTP.get_response(uri)

          uri.dup.to_s if response.code == '200'
        end

      methods = {
        'robots.txt' => robot_method,
        'sitemap.xml' => sitemap_xml_method,
        'sitemap.xml.gz' => sitemap_xml_method,
        'sitemap_index.xml' => sitemap_xml_method,
        'sitemap_index.xml.gz' => sitemap_xml_method
      }

      sitemap = nil
      sitemap_id = SecureRandom.uuid

      crawler_domain.possible_uris.each do |uri|
        methods.each do |method_file, method_processor|
          uri.path = "/#{method_file}"

          sitemap =
            (
              begin
                method_processor.call(uri)
              rescue StandardError
                nil
              end
            )

          if sitemap
            verify_sitemap(
              crawler_domain,
              provider_crawler,
              sitemap.to_s,
              sitemap_id
            )
            return
          end
        end
      end

      log(
        crawler_domain.id,
        '#110004: Could not detect sitemap automatically',
        :error
      )
    rescue StandardError => e
      log(
        crawler_domain.id,
        '#110004: Could not detect sitemap automatically',
        :error
      )
    end

    def verify_sitemap(
      crawler_domain, provider_crawler, sitemap_url, sitemap_id
    )
      log(crawler_domain.id, 'Sitemap detected, enqueuing for verification')

      provider_crawler.update(
        sitemaps: [
          {
            id: sitemap_id,
            url: sitemap_url,
            type: 'unknown',
            status: 'unverified'
          }
        ]
      )
      ::Developers::SitemapVerificationJob.enqueue(
        provider_crawler.id,
        sitemap_id
      )
    end

    def setup_provider_crawler(crawler_domain, provider_crawler)
      log(crawler_domain.id, 'Configuring domain crawler')

      crawler_service =
        ::Integration::Napoleon::ProviderCrawlerService.new(provider_crawler)

      crawler_service.call

      if crawler_service.error
        raise crawler_service.error
      else
        log(crawler_domain.id, 'Successfully configured domain crawler')
      end
    rescue StandardError => e
      log(crawler_domain.id, '#100008: Domain configuration failed', :error)
    end

    def log(ctx_id, message, level = :info)
      self.logger.public_send(
        level,
        {
          id: SecureRandom.uuid,
          ps: { id: ctx_id, name: SERVICE_NAME },
          payload: message
        }.to_json
      )
    end
  end
end
