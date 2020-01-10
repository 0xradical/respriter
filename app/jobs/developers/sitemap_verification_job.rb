require 'syslogger'

module Developers
  class SitemapVerificationJob < Que::Job
    class Error < StandardError; end
    SERVICE_NAME = 'sitemap-verification-service'

    self.priority = 100

    attr_reader :logger

    def initialize(*)
      super

      @logger = SysLogger.new
    end

    def run(id, sitemap_id)
      log(sitemap_id, 'Started sitemap verification')

      provider_crawler = ProviderCrawler.find(id)

      sitemap = provider_crawler.sitemaps.first

      if sitemap
        sitemap[:status] = 'verified'
        sitemap[:type] = 'sitemap'
        provider_crawler.sitemaps_will_change!
        provider_crawler.save
      end

      log(sitemap_id, 'Finished sitemap verification')
      finish
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
