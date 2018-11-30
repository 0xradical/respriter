module Api
  module Admin
    module V1

      class EnrollmentsController < BaseController

        def index
          @enrollments = Enrollment.page(params[:p])
          render json: EnrollmentSerializer.new(@enrollments)
        end

      end

    end
  end
end
