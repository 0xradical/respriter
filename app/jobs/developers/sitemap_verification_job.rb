require 'syslogger'
require_relative '../../../lib/sitemap/validator.rb'

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
      sitemap_validator = Sitemap::Validator.new
      sitemap = provider_crawler.sitemaps.first

      raise "Sitemap with id #{sitemap_id} not found" if sitemap.nil?

      log(sitemap_id, 'Fetching sitemap')
      response = Net::HTTP.get_response(URI.parse(sitemap[:url].to_s))

      if response.code != '200'
        raise "Sitemap URL returned status code #{response.code}"
      end

      validation = sitemap_validator.validate(response.body)

      case validation
      when :invalid
        raise 'Sitemap is not valid'
      when :error
        raise 'Error while detecting sitemap type'
      else
        ProviderCrawler.transaction do
          log(sitemap_id, 'Successfully detected sitemap type')
          update_sitemap(sitemap, provider_crawler, 'verified', validation)
          log(sitemap_id, 'Finished sitemap verification')
          finish
        end
      end
    rescue => e
      error = e
    ensure
      if error
        ProviderCrawler.transaction do
          update_sitemap(sitemap, provider_crawler, 'invalid', 'unknown')
          expire
        end

        log(id, "Finished sitemap verification with error: #{error}", :error)
      end
    end

    def update_sitemap(sitemap, provider_crawler, status, type)
      sitemap[:status] = status
      sitemap[:type] = type
      provider_crawler.sitemaps_will_change!
      provider_crawler.save
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
