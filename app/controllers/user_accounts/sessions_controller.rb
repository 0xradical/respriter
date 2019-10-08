# frozen_string_literal: true

class UserAccounts::SessionsController < Devise::SessionsController
  protect_from_forgery prepend: true

  skip_before_action :verify_authenticity_token, if: :json_request?
  skip_before_action :verify_signed_out_user, only: :destroy, if: :json_request?

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    sign_out :user_account
    session[:current_user_jwt] = nil
    response.set_header('Access-Control-Allow-Origin', request.origin)
    response.set_header('Access-Control-Allow-Credentials', true)

    respond_to do |format|
      format.json { head :ok }
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
