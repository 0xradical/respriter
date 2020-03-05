module Developers
  class SessionsController < ::UserAccounts::SessionsController
    def new
      flash[:notice] =
        'You must be signed in on Classpert.com to access the Index Tool dashboard'
      redirect_to user_account_session_path
    end

    protected

    def set_login_redirect_location
      if session[:login_redirect_location].presence.nil?
        redirect_url = ENV.fetch('DEVELOPERS_DASHBOARD_URL')
        redirect_path = params[:developers_dashboard_redir].presence || '/'

        session[:login_redirect_location] = "#{redirect_url}#{redirect_path}"
      end
    end
  end
end
