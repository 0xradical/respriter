module Api
  module User
    module V1

      class AccountsController < BaseController

        def show
          @account = current_user_account
          render json: AccountSerializer.new(@account, {include: [:profile, :oauth_accounts] }).serialized_json
        end

        def update
          current_user_account.profile.preferences_will_change!
          current_user_account.profile.preferences = profile_params[:preferences]
          current_user_account.profile.save
          render json: current_user_account.reload
        end

        private

        def profile_params
          params.require(:profile).permit(preferences: :locale)
        end

      end

    end
  end
end

