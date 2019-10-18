# frozen_string_literal: true

class UserAccounts::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :find_or_create_user_account, only: [:github, :facebook, :linkedin]

  def github
    sign_in_and_redirect @user_account, scope: :user_account
  end

  def linkedin
    sign_in_and_redirect @user_account, scope: :user_account
  end

  def facebook
    sign_in_and_redirect @user_account, scope: :user_account
  end

  # def passthru
    # super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
    # super
  # end

  # protected

  def find_or_create_user_account
    @user_account = OauthAccount.user_account_from!(oauth: request.env['omniauth.auth'], session: session)
  end

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

end
