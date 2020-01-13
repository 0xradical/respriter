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

      crawler_domain = CrawlerDomain.find(id)
      user_account = UserAccount.find(user_id)

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
            log(id, 'Could not verify domain, will try again shortly', :error)

            raise DomainAuthorityVerificationJob::Error
          else
            CrawlerDomain.transaction do
              crawler_domain.update(authority_confirmation_status: 'failed')
              expire
            end

            log(id, 'Could not verify domain, exceeded number of tries', :error)
          end
        end
      end
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
      rescue StandardError => e
        raise "Error while deriving name from domain: #{e.message}"
      end

      if provider_name
        log(crawler_domain.id, 'Successfully derived name from domain')
      else
        raise 'Could not derive name from domain'
      end

      ApplicationRecord.transaction do
        provider = Provider.create(name: provider_name)

        provider_crawler =
          ProviderCrawler.create(
            { provider_id: provider.id, user_account_ids: [user_id] }
          )

        crawler_domain.update(
          {
            authority_confirmation_status: 'confirmed',
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
      end

      finish
    end

    def detect_sitemap(crawler_domain, provider_crawler)
      log(crawler_domain.id, 'Trying to detect sitemap automatically')

      sitemap = nil
      sitemap_id = SecureRandom.uuid

      crawler_domain.possible_uris.each do |uri|
        begin
          # robots.txt
          uri.path = '/robots.txt'

          robots_parser = Robotstxt.get(uri, 'Classpert Bot')
          sitemap = robots_parser.sitemaps.first.presence
        rescue StandardError
          nil
        end

        if sitemap
          verify_sitemap(
            crawler_domain,
            provider_crawler,
            sitemap.to_s,
            sitemap_id
          )
          return
        end

        begin
          # sitemap.xml
          uri.path = '/sitemap.xml'

          response = Net::HTTP.get_response(uri)

          sitemap = uri.dup.to_s if response.code == '200'
        rescue StandardError
          nil
        end

        if sitemap
          verify_sitemap(
            crawler_domain,
            provider_crawler,
            sitemap.to_s,
            sitemap_id
          )
          return
        end

        begin
          # sitemap.xml
          uri.path = '/sitemap.xml.gz'

          response = Net::HTTP.get_response(uri)

          sitemap = uri.dup.to_s if response.code == '200'
        rescue StandardError
          nil
        end

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

      log(crawler_domain.id, 'Could not detect sitemap automatically', :error)
    rescue StandardError => e
      log(
        crawler_domain.id,
        "Could not detect sitemap automatically: #{e.message}",
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
      log(
        crawler_domain.id,
        "Configuration of domain crawler failed with error: #{e.message}",
        :error
      )
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
