# frozen_string_literal: true

class UserAccounts::SessionsController < Devise::SessionsController
  protect_from_forgery prepend: true

  before_action  :destroy_api_session,            only: :destroy
  before_action  :set_user_dashboard_redir,       only: :new
  before_action  :set_developers_dashboard_redir, only: :new

  protected

  def set_user_dashboard_redir
    session[:user_dashboard_redir] = params[:user_dashboard_redir]
  end

  def set_developers_dashboard_redir
    session[:developers_dashboard_redir] = params[:developers_dashboard_redir]
  end

  def destroy_api_session
    session[:current_user_jwt] = nil
    cookies.delete :_jwt,         domain: :all
    cookies.delete :_csrf_token,  domain: :all
  end

end
