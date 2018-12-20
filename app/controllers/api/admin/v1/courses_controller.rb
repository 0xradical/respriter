module Api
  module Admin
    module V1

      class CoursesController < BaseController

        def create
          @posts = Course.create(request.parameters[:data])
          render json: @posts
        end

        def import
          @courses = Course.import_from_csv(csv_file[:file], [:url])
          render json: @courses
        end

        private

        def csv_file
          params.permit(:file)
        end

      end

    end
  end
end
