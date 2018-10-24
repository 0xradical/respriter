module Api
  module User
    module V1
      class ImagesController < BaseController

        def create
          @image = current_user_account.profile.attach_image!(image_params)
          render json: ImageSerializer.new(@image)
        end

        private

        def image_params
          params.permit(:file, :id)
        end

      end
    end
  end
end
