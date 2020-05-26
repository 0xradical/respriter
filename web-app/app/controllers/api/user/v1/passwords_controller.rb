module Api
  module User
    module V1
      class PasswordsController < BaseController

        def create
          #if current_user_account.password.blank?
            @user_account = current_user_account
            raw, enc = Devise.token_generator.generate(UserAccount, :reset_password_token)
            current_user_account.reset_password_token   = enc
            current_user_account.reset_password_sent_at = Time.now.utc
            current_user_account.save(validate: false)
            Devise.sign_out_all_scopes ? sign_out : sign_out(:user_account)
            redirect_to edit_password_path(@user_account, reset_password_token: raw)
          #end
        end

      end
    end
  end
end
