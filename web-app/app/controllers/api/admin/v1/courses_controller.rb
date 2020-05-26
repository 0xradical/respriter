module Api
  module Admin
    module V1

      class CoursesController < BaseController

        def update
          @course = Course.find(params[:id])
          @course.update(course_params)
          @course.__elasticsearch__.index_document
          render json: CourseSerializer.new(@course)
        end

        private

        def course_params
          params.require(:course).permit(:curated_tags).tap do |param|
            param[:curated_tags] = param[:curated_tags].split(',')
          end
        end

      end

    end
  end
end
