module Api
  module Admin
    module V1

      class BaseController < ActionController::API
        before_action :authenticate_admin_account!
      end

    end
  end
end

