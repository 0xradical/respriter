module Api
  module User
    module V1

      class OauthAccountsController < BaseController

        def destroy
          @oauth_account = current_user_account.oauth_accounts.find_by(provider: params[:id])
          @oauth_account.destroy!
          render json: OauthAccountSerializer.new(current_user_account.oauth_accounts.reload)
        end

      end

    end
  end
end
