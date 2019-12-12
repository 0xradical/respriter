module Api
  module User
    module V1
      class ImagesController < BaseController

        def create
          # deprecated
          @image = current_user_account.profile.attach_image!(image_params)
          current_user_account.profile.update(uploaded_avatar_url: @image.file_url)
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
