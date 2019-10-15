# frozen_string_literal: true

class UserAccounts::SessionsController < Devise::SessionsController
  protect_from_forgery prepend: true

  skip_before_action :verify_signed_out_user, only: :destroy, if: :json_request?

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    session[:user_dashboard_redir] = params[:user_dashboard_redir]
    super
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    sign_out :user_account
    session[:current_user_jwt] = nil
    respond_to do |format|
      format.json { head :ok }
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(:user_account) }
    end
  end

  protected

  def json_request?
    request.format.json?
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
