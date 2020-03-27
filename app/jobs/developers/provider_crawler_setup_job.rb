module Developers
  class ProviderCrawlerSetupJob < BaseJob
    SERVICE_NAME = 'provider-crawler-setup-service'
    attr_accessor :error

    def run(
      provider_crawler_id,
      service_name = SERVICE_NAME,
      session_id = provider_crawler_id
    )
      job =
        Class.new(self.class).tap do |klass|
          klass.session_id = session_id
          klass.service_name = service_name
          klass.user_agent_token =
            ProviderCrawler.find_by(id: provider_crawler_id)&.user_agent_token
        end.new({})

      job.process(provider_crawler_id)
    end

    def process(id)
      log('Configuring domain crawler')

      provider_crawler = ProviderCrawler.find_by(id: id)
      if provider_crawler.nil?
        raise '#110000: Domain Crawler not found on database'
      end

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
      self.error = e
      log('#100008: Domain configuration failed', :error)
    end
  end
end
