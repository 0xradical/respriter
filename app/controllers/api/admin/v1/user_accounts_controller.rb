module Api
  module Admin
    module V1

      class UserAccountsController < BaseController

        def index
          @user_accounts = UserAccount.page(params[:p])
          render json: UserAccountSerializer.new(@user_accounts)
        end

      end

    end
  end
end

