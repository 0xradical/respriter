module Api
  module Admin
    module V2

      class AvatarsController < ActionController::API

        def create
          @image = current_admin_account.profile.attach_image!(avatar_params)
          render json: ImageSerializer.new(@image)
        end

        private

        def avatar_params
          params.require(:avatar).permit(:file)
        end

      end

    end
  end
end
