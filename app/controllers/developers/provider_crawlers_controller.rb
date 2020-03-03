module Developers
  class ProviderCrawlersController < ApplicationController
    def start
      service.start
      render json: { scheduled: true }
    rescue Integration::Napoleon::ProviderCrawlerService::CrawlerNotReady
      render json: { scheduled: false, error: 'crawler not ready' }, status: :bad_request
    end

    def stop
      service.stop
      render json: { scheduled: false }
    rescue Integration::Napoleon::ProviderCrawlerService::CrawlerNotReady
      render json: { scheduled: false, error: 'crawler not ready' }, status: :bad_request
    end

    protected
    def service
      return @service if @service.present?

      @provider_crawler ||= ProviderCrawler
        .where('? = ANY(user_account_ids)', current_user_account.id)
        .find( params[:id] )

      @service ||= Integration::Napoleon::ProviderCrawlerService.new @provider_crawler
    end
  end
end
