# frozen_string_literal: true

class UserAccounts::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :create_oauth_session, only: [:github, :facebook, :linkedin]

  def github
    redirect_to user_accounts_dashboard_path('dashboard')
    #render :success
  end

  def linkedin
    redirect_to user_accounts_dashboard_path('dashboard')
    #render :success
  end

  def facebook
    redirect_to user_accounts_dashboard_path('dashboard')
    #render :success
  end

  # def passthru
    # super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  def create_oauth_session
    if user_account_signed_in?
      current_user_account.add_oauth_account(request.env['omniauth.auth'])
    else
      @user_account = OauthAccount.from_provider(oauth: request.env['omniauth.auth'])
      sign_in @user_account, scope: :user_account
    end
  end

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
