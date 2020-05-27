require 'dnsruby'

module Developers
  class DomainAuthorityVerificationJob < BaseJob
    SERVICE_NAME = 'domain-validation-service'
    RETRY_MAX = 10
    RETRY_WINDOW = 30 # seconds
    RETRY_HEARTBEATS = 5

    attr_accessor :retries

    def initialize(*)
      super
      @exit = false
      @retries = 0
      @elapsed = 0
    end

    def run(crawler_domain_id, user_account_id, session_id)
      job =
        Class.new(self.class).tap do |klass|
          klass.session_id = session_id
          klass.service_name = SERVICE_NAME
          klass.user_agent_token = nil
        end.new({})

      job.process(crawler_domain_id, user_account_id)
    end

    def process(id, user_id)
      log('Started domain verification')

      crawler_domain = CrawlerDomain.find_by(id: id)
      if crawler_domain.nil?
        raise '#100000: Domain structure not found on database'
      end

      user_account = UserAccount.find_by(id: user_id)
      if user_account.nil?
        raise "#100001: Domain's associated user not found on database"
      end

      if crawler_domain.reload.authority_confirmation_status == 'confirmed'
        raise '#100002: Domain already validated'
      end

      if crawler_domain.reload.authority_confirmation_status == 'confirming'
        raise '#100009: Domain already being validated'
      end

      if crawler_domain.reload.authority_confirmation_status.in?(
           %w[unconfirmed failed]
         )
        crawler_domain.update(authority_confirmation_status: 'confirming')
      end

      loop do
        log('Retrying verification') if (self.retries > 0)

        if check_html(crawler_domain, user_account)
          confirm!(user_id, crawler_domain, 'html')
          log('Successfully verified domain via HTML')

          return
        elsif check_dns(crawler_domain, user_account)
          confirm!(user_id, crawler_domain, 'dns')
          log('Successfully verified domain via DNS')

          return
        else
          self.retries += 1

          if self.retries <= RETRY_MAX
            log('#100004: Domain validation failed temporarily', :error)
            start_heartbeat(crawler_domain)
          else
            CrawlerDomain.transaction do
              crawler_domain.update(authority_confirmation_status: 'failed')
              expire
            end

            log('#100005: Domain validation failed permanently', :error)
            return
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

      log(e.message, :error)
    end

    def check_html(crawler_domain, user_account)
      log('Verifying HTML page')

      crawler_domain.possible_uris.each do |u|
        begin
          uri = URI.parse(u.to_s)
          log("Trying #{uri.scheme.upcase} (#{uri.to_s})")
          response = get_response(uri)

          if response.code == '200'
            document = Nokogiri.HTML(response.body)

            document.css('meta').each do |meta|
              if meta.attributes['name']&.value ==
                   UserAccount::DOMAIN_VERIFICATION_KEY &&
                   meta.attributes['content']&.value ==
                     user_account.domain_verification_token
                return true
              end
            end
          else
            log(
              "HTML Verification for #{u.to_s} failed (status code: #{
                response.code
              })"
            )
          end
        rescue StandardError
          log('Could not verify via HTML')
          false
        end
      end

      false
    end

    def check_dns(crawler_domain, user_account)
      log('Verifying DNS entries')
      resolver = Dnsruby::DNS.new

      # DNS by TXT entry
      begin
        log('Looking for token in TXT DNS entries')
        resolver.each_resource(crawler_domain.domain, 'TXT') do |rr|
          return true if rr.data == user_account.domain_verification_txt_entry
        end
        log('Could not find matching TXT DNS entries')
      rescue Exception => e
        log('Could not verify via TXT DNS entries')
        nil
      end

      begin
        log('Looking for token in CNAME DNS entries')
        resolver.each_resource(
          user_account.domain_verification_cname_entry(crawler_domain.domain),
          'CNAME'
        ) { |rr| return true if rr.rdata.to_s == 'verification.classpert.com' }
        log('Could not find matching CNAME DNS entries')
      rescue Exception => e
        log('Could not verify via CNAME DNS entries')
      end

      false
    end

    def confirm!(user_id, crawler_domain, confirmation_method)
      user_account = UserAccount.find_by(id: user_id)
      provider = nil
      provider_crawler = nil
      provider_name = nil

      log('Deriving name from domain')

      begin
        parsed_domain = PublicSuffix.parse(crawler_domain.domain)
        digest = Digest::MD5.hexdigest(crawler_domain.domain)[0..4]

        provider_name =
          [parsed_domain.trd, parsed_domain.sld].compact.flat_map(&:to_s)
            .select do |domain_part|
            domain_part != 'www'
          end.flat_map do |domain_part|
            derived =
              domain_part.split(/\./).map do |part|
                part.gsub(/\-/, '_').gsub(/[^A-Za-z0-9_]/, '').camelcase
              end.join(' ')
            [
              { pos: 1, value: derived },
              { pos: 2, value: "#{derived} ##{digest}" }
            ]
          end.sort_by { |h| h[:pos] }.select do |h|
            Provider.where(name: h[:value]).count == 0
          end.first
            &.fetch(:value)
      rescue StandardError
        raise '#100006: Name derived from domain url cannot be used'
      end

      if provider_name
        log('Successfully derived name from domain')
      else
        raise '#100007: Name derivation from domain failed'
      end

      crawler_domain.reload

      if crawler_domain.provider_crawler_id
        raise 'Domain already validated by someone else'
      else
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
                user_account.domain_verification_token,
              authority_confirmation_status: 'confirmed',
              authority_confirmation_salt: ENV['DOMAIN_VERIFICATION_SALT'],
              provider_crawler_id: provider_crawler.id
            }
          )
        end
      end

      if provider && provider_crawler
        detect_sitemap(crawler_domain, provider_crawler)
        setup_provider_crawler(provider_crawler)
      else
        raise 'Database error'
      end
    rescue StandardError => e
      raise "Confirmation failed: #{e.message}"
    end

    def detect_sitemap(crawler_domain, provider_crawler)
      log('Trying to detect sitemap automatically')

      robot_method =
        proc do |uri|
          robots_parser = Robotstxt.get(uri, 'Classpert Bot')
          robots_parser.sitemaps.first.presence
        end
      sitemap_xml_method =
        proc do |uri|
          response = get_response(uri)

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
          log("Looking for #{uri.to_s}")

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
          else
            log("Could not find #{uri.to_s}")
          end
        end
      end

      log('#110004: Could not detect sitemap automatically', :error)
    rescue StandardError => e
      log('#110004: Could not detect sitemap automatically', :error)
    end

    def verify_sitemap(
      crawler_domain, provider_crawler, sitemap_url, sitemap_id
    )
      log('Sitemap detected, enqueuing for validation')

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

      ::Developers::SitemapVerificationJob.new({}).run(
        provider_crawler.id,
        sitemap_id,
        self.class.session_id
      )
    end

    def setup_provider_crawler(provider_crawler)
      job = ::Developers::ProviderCrawlerSetupJob.new({})

      job.run(provider_crawler.id, SERVICE_NAME, self.class.session_id)

      raise job.error if job.error
    end

    def start_heartbeat(crawler_domain)
      @exit = false
      @elapsed = 0
      @begin = Time.now

      @heartbeat =
        Thread.new do
          while !@exit
            sleep(RETRY_WINDOW / RETRY_HEARTBEATS)
            @elapsed = (Time.now - @begin).to_i

            if (@elapsed < RETRY_WINDOW)
              log(
                "Will retry verification in #{
                  (RETRY_WINDOW - @elapsed).abs
                } seconds (#{self.retries} out of #{RETRY_MAX} retries)"
              )
            else
              stop_heartbeat
            end
          end
        end
      Signal.trap('INT') do
        @exit = true
        exit
      end

      sleep(RETRY_WINDOW)
    end

    def stop_heartbeat
      @heartbeat.kill if !@exit
    end
  end
end