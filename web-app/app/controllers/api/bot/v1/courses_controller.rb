module Api
  module Bot
    module V1

      class CoursesController < ActionController::API

        def create
          @courses = Course.bulk_upsert(request.parameters[:data])
          render json: @courses
        end

      end

    end
  end
end

