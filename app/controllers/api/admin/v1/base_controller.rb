module Api
  module Admin
    module V1

      class BaseController < ActionController::API

        prepend_before_action :authenticate_admin_account!
        before_action :load_resource_defs

        def index
          @collection = @resource_klass.order(created_at: :desc).page(params[:p]).per(params[:_limit])
          options = { meta: { total: @collection.total_count } }
          render json: @serializer_klass.new(@collection, options).serialized_json
        end

        private

        def load_resource_defs
          self.class.to_s.match(/Api::Admin::V1::([a-zA-Z]*)Controller/)
          @resource_klass   = $1.singularize.constantize
          @serializer_klass = "Api::Admin::V1::#{$1.singularize}Serializer".constantize 
        end

      end

    end
  end
end

