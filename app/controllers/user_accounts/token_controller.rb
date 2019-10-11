class UserAccounts::TokenController < ApplicationController
  protect_from_forgery prepend: true

  skip_before_action :verify_authenticity_token

  def token
    set_csrf_cookie
    render json: { token: SessionToken.decrypt(params[:token], request_ip) }
  end


end
