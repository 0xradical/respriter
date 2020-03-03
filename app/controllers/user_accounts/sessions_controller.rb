class UserAccounts::SessionsController < Devise::SessionsController
  protect_from_forgery prepend: true

  before_action :destroy_api_session, only: :destroy
  before_action :set_login_redirect_location, only: :new

  protected

  def set_login_redirect_location
    if session[:login_redirect_location].presence.nil?
      redirect_url = ENV.fetch('USER_DASHBOARD_URL')
      redirect_path = params[:user_dashboard_redir].presence || '/'

      session[:login_redirect_location] = "#{redirect_url}#{redirect_path}"
    end
  end

  def destroy_api_session
    session[:current_user_jwt] = nil
    cookies.delete :_jwt, domain: :all
    cookies.delete :_csrf_token, domain: :all
  end
end
