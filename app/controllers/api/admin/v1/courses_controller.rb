module Api
  module Admin
    module V1

      class CoursesController < BaseController

        def index
          @courses = Course.all
          render json: @courses
        end

        def create
          @posts = Course.create(request.parameters[:data])
          render json: @posts
        end

        # private

        # def data
          # params.require(:data).permit(:name, :portal_id, :[])
        # end

      end

    end
  end
end
