module Api
  module Admin
    module V2

      class ProfilesController < ActionController::API

        def edit
          @profile = current_admin_account.profile
          render json: AdminProfileSerializer.new(@profile, params).serialized_json
        end

        def update
          @profile = current_admin_account.profile
          @profile.update(profile_params)
          render json: AdminProfileSerializer.new(@profile)
        end

        private

        def profile_params
          params.require(:admin_profile).permit(:name, :bio)
        end

      end

    end
  end
end
