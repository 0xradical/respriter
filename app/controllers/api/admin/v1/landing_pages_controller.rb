module Api
  module Admin
    module V1

      class LandingPagesController < BaseController

        def show
          @landing_page = LandingPage.find(params[:id])
          render json: LandingPageSerializer.new(@landing_page)
        end

        def update
          @landing_page = LandingPage.find(params[:id])
          @landing_page.update(landing_page_params)
          render json: LandingPageSerializer.new(@landing_page)
        end

        def create
          @landing_page = LandingPage.create(landing_page_params)
          render json: LandingPageSerializer.new(@landing_pages)
        end

        private

        def landing_page_params
          params.require(:landing_page).permit(:slug, :id, :template, html: {}, data: {})
        end

      end

    end
  end
end
