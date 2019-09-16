# frozen_string_literal: true

class AdminAccounts::SessionsController < Devise::SessionsController
  respond_to :json

  skip_before_action :verify_authenticity_token, if: :json_request?
  #protect_from_forgery unless: -> { request.format.json? }, prepend: true
  #protect_from_forgery with: :null_session

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
  # def destroy
  #   super
  # end

  protected

  def json_request?
    request.format.json?
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
