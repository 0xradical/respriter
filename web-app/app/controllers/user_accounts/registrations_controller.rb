# frozen_string_literal: true
require_relative '../../../lib/pg/result_processor.rb'

class UserAccounts::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: %i[create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)
    captcha_verified = verify_rucaptcha?(resource)
    resource_saved = false

    if captcha_verified
      ActiveRecord::Base.transaction do
        begin
          resource_saved = resource.save
        rescue ActiveRecord::StatementInvalid => e
          pg_processor = PG::ResultProcessor.new(e.cause.result)
          resource.errors.add(
            :base,
            I18n.t("db.#{pg_processor.error}"),
            field: :username
          )
          resource_saved = false
          raise ActiveRecord::Rollback
        end
      end

      if resource_saved
        yield resource if block_given?
        if resource.persisted?
          if resource.active_for_authentication?
            set_flash_message! :notice, :signed_up
            sign_up(resource_name, resource)
            respond_with resource, location: after_sign_up_path_for(resource)
          else
            set_flash_message! :notice,
                               :"signed_up_but_#{resource.inactive_message}"
            expire_data_after_sign_in!
            respond_with resource,
                         location: after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords resource
          set_minimum_password_length
          respond_with_navigational(resource) { render :new }
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with_navigational(resource) { render :new }
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with_navigational(resource) { render :new }
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update; end

  # DELETE /resource
  def destroy
    resource.soft_delete
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource) do
      redirect_to after_sign_out_path_for(resource_name)
    end
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected
  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up).merge(
      { tracking_data: session[:tracking_data] }
    )
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:tracking_data, profile_attributes: %i[username]]
    )
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end