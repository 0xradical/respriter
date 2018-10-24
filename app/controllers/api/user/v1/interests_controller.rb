module Api
  module User
    module V1

      class InterestsController < BaseController

        def index
          @interests = I18n.backend.send(:translations)[:en][:tags].keys
          render json: (@interests - current_user_account.profile.interests.map(&:to_sym))
        end

        def create
          current_user_account.profile.interests << params[:id]
          current_user_account.profile.save
          render json: current_user_account.profile.interests
        end

        def destroy
          interests = current_user_account.profile.interests
          interests.delete_if { |tag| tag == params[:id] }
          current_user_account.profile.update({interests: interests})
          render json: current_user_account.profile.reload.interests
        end

      end

    end
  end
end


