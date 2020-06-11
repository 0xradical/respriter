# frozen_string_literal: true
class UserAccounts::PasswordsController < Devise::PasswordsController

  skip_before_action :require_no_authentication, :only => [:edit, :update]

  respond_to :json

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    super unless current_user_account.autogen_email_for_oauth
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

 # protected

  # def after_resetting_password_path_for(resource)
    # user_dashboard_url
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

end
