require_relative '../../../lib/sitemap/validator.rb'

module Developers
  class SitemapVerificationJob < BaseJob
    SERVICE_NAME = 'sitemap-verification-service'

    def run(provider_crawler_id, sitemap_id, session_id = sitemap_id)
      job = Class.new(self.class).tap do |klass|
        klass.session_id = session_id
        klass.service_name = SERVICE_NAME
        klass.user_agent_token = ProviderCrawler.find_by(id: provider_crawler_id)&.user_agent_token
      end.new({})

      job.process(provider_crawler_id, sitemap_id)
    end

    def process(id, sitemap_id)
      log('Started sitemap verification')

      provider_crawler = ProviderCrawler.find_by(id: id)
      if provider_crawler.nil?
        raise '#110000: Sitemap structure not found on database'
      end

      sitemap_validator = Sitemap::Validator.new
      sitemap = provider_crawler.sitemaps.first

      raise '#110000: Sitemap structure not found on database' if sitemap.nil?

      log('Fetching sitemap')
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
          log('Successfully detected sitemap type')
          update_sitemap(sitemap, provider_crawler, 'verified', validation)
          setup_provider_crawler(provider_crawler)
          log('Finished sitemap verification')
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

        log(error.message, :error)
      end
    end

    def update_sitemap(sitemap, provider_crawler, status, type)
      sitemap[:status] = status
      sitemap[:type] = type
      provider_crawler.sitemaps_will_change!
      provider_crawler.save
    end

    def setup_provider_crawler(provider_crawler)
      log('Configuring domain crawler')

      crawler_service =
        ::Integration::Napoleon::ProviderCrawlerService.new(
          provider_crawler.reload
        )

      crawler_service.prepare

      if crawler_service.error
        raise crawler_service.error
      else
        log('Successfully configured domain crawler')
      end
    rescue StandardError => e
      log('#100008: Domain configuration failed', :error)
    end
  end
end
