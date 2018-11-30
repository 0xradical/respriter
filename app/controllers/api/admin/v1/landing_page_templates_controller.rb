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

        def preview
          renderer = ApplicationController.renderer.new
          renderer.instance_variable_set(:@env, {
            "HTTP_HOST"=>"localhost:3000",
            "HTTPS"=>"off",
            "REQUEST_METHOD"=>"GET",
            "SCRIPT_NAME"=>"",
            "warden" => warden
          })
          render json: { 
            id: params[:id],
            template: renderer.render('landing_page_templates/courses.html.erb')
          }

        end

        def show
          lp_tpl = LandingPageTemplate.new('courses.html.erb', {
            "HTTP_HOST"=>"localhost:3000",
            "HTTPS"=>"off",
            "REQUEST_METHOD"=>"GET",
            "SCRIPT_NAME"=>"",
            "warden" => warden
          })
          render json: LandingPageTemplateSerializer.new(lp_tpl)
        end

 

      end

    end
  end
end

