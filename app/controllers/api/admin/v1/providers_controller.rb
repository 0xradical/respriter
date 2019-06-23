module Api
  module Admin
    module V1

      class ProvidersController < BaseController

        def index
          @providers = Provider.page(params[:p]).per(params[:limit])
          render json: ProviderSerializer.new(@providers, { meta: { count: @providers.total_count } })
        end

      end

    end
  end
end

