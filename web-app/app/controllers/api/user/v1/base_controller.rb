class Api::User::V1::BaseController < ActionController::API
  prepend_before_action :authenticate_user_account!
end
