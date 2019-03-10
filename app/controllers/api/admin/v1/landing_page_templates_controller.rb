module Api
  module Admin
    module V1

      class LandingPageTemplatesController < BaseController

        def index
          @layouts = Dir.glob(Rails.root.join('app', 'views', 'layouts', 'landing_pages', '**')).map do |l|
            File.basename(l,'.html.erb')
          end
          render json: @layouts
        end

        def show
          lp_tpl = LandingPageTemplate.new("#{params[:id]}.html.erb")
          render json: LandingPageTemplateSerializer.new(lp_tpl)
        end

      end

    end
  end
end

