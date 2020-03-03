require_relative '../../../lib/sitemap/validator.rb'

module Developers
  class SitemapVerificationJob < Que::Job
    class Error < StandardError; end
    SERVICE_NAME = 'sitemap-verification-service'

    self.priority = 100
    class << self
      attr_accessor :session_id
    end

    attr_reader :logger

    def initialize(*)
      super
      @logger = Logger.new(STDOUT)
      @logger.formatter =
        proc { |severity, datetime, progname, msg| "#{msg}\n" }
    end

    def run(id, sitemap_id)
      verify(id, sitemap_id)
    end

    def verify(id, sitemap_id)
      log(sitemap_id, 'Started sitemap verification')

      provider_crawler = ProviderCrawler.find_by(id: id)
      if provider_crawler.nil?
        raise '#110000: Sitemap structure not found on database'
      end

      sitemap_validator = Sitemap::Validator.new
      sitemap = provider_crawler.sitemaps.first

      raise '#110000: Sitemap structure not found on database' if sitemap.nil?

      log(sitemap_id, 'Fetching sitemap')
      response = get_response(URI.parse(sitemap[:url].to_s))

      if response.code != '200'
        raise "#110001: Sitemap URL returned status code #{response.code}"
      end

      validation = sitemap_validator.validate(response.body)

      case validation
      when :invalid
        raise '#110002: Sitemap is not valid'
      when :error
        raise '#110003: Error while detecting sitemap type'
      else
        ProviderCrawler.transaction do
          log(sitemap_id, 'Successfully detected sitemap type')
          update_sitemap(sitemap, provider_crawler, 'verified', validation)
          setup_provider_crawler(sitemap_id, provider_crawler)
          log(sitemap_id, 'Finished sitemap verification')
          finish
        end
      end
    rescue => e
      error = e
    ensure
      if error
        if provider_crawler && sitemap
          ProviderCrawler.transaction do
            update_sitemap(sitemap, provider_crawler, 'invalid', 'unknown')
            expire
          end
        else
          expire
        end

        log(id, error.message, :error)
      end
    end

    def update_sitemap(sitemap, provider_crawler, status, type)
      sitemap[:status] = status
      sitemap[:type] = type
      provider_crawler.sitemaps_will_change!
      provider_crawler.save
    end

    def setup_provider_crawler(id, provider_crawler)
      log(id, 'Configuring domain crawler')

      crawler_service =
        ::Integration::Napoleon::ProviderCrawlerService.new(
          provider_crawler.reload
        )

      crawler_service.prepare

      if crawler_service.error
        raise crawler_service.error
      else
        log(id, 'Successfully configured domain crawler')
      end
    rescue StandardError => e
      log(id, '#100008: Domain configuration failed', :error)
    end

    def log(ctx_id, message, level = :info)
      self.logger.public_send(
        level,
        {
          id: SecureRandom.uuid,
          ps: { id: (self.class.session_id || ctx_id), name: SERVICE_NAME },
          payload: message
        }.to_json
      )
    end

    def get_response(url)
      Net::HTTP.start(
        url.host,
        url.port,
        use_ssl: url.scheme == 'https', open_timeout: 10, read_timeout: 10
      ) do |http|
        request = Net::HTTP::Get.new url

        response = http.request request
      end
    rescue Net::OpenTimeout
      raise "Timeout while trying to access #{url}"
    end
  end
end
