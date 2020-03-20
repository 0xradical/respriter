# frozen_string_literal: true

class UserAccounts::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :add_oauth_account_or_sign_in

  %i[github reddit twitter linkedin facebook].each do |provider| 
    define_method provider do; end
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
      sign_in oauth_acc.user_account, scope: :user_account
    end

    if request.env['omniauth.origin'] =~ /\/claims\/social\/[a-zA-Z0-9_-]*$/
      session[:claim_with] = oauth_acc.id
    end

    redirect_to request.env['omniauth.origin'] and return
  end

end
