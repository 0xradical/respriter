module Api
  module Admin
    module V1

      class LandingPagesController < BaseController

        def index
          @landing_pages = LandingPage.page(params[:p])
          render json: LandingPageSerializer.new(@landing_pages)
        end

        def create
          @landing_page = LandingPage.create(landing_page_params)
          render json: LandingPageSerializer.new(@landing_pages)
        end

        private

        def landing_page_params
          params.require(:landing_page).permit(:slug, :template, html: {})
        end

      end

    end
  end
end
