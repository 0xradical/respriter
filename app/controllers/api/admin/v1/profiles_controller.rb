module Api
  module Admin
    module V1

      class ProfilesController < BaseController

        def update
          current_admin_account.update(preferences_params)
          render json: @serializer_klass.new(current_admin_account).serialized_json
        end

        private

        def preferences_params
          params.require(:profile).permit(preferences: {})
        end

      end

    end
  end
end
