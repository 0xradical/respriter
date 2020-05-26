# frozen_string_literal: true

class UserAccounts::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :add_oauth_account_or_sign_in, only: [:github, :twitter, :linkedin, :facebook]

  %i[github twitter linkedin facebook].each do |provider| 
    define_method provider do
      sign_in_and_redirect @user_account, scope: :user_account
    end
  end

  protected

  def add_oauth_account_or_sign_in
    oauth_data = request.env['omniauth.auth']

    if user_account_signed_in?
      oauth_acc = current_user_account
      .oauth_accounts
      .find_or_create_by(uid: oauth_data[:uid], provider: oauth_data[:provider]) { |oauth_acc| oauth_acc.raw_data = oauth_data }
    else
      oauth_acc = OauthAccount.user_account_from!(oauth: oauth_data, session: session)
    end

    session[:claim_with] = oauth_acc.id if request.env['omniauth.origin'] =~ /\/claims\/social\/[a-zA-Z0-9_-]*$/

    @user_account = oauth_acc.user_account
  end

end
