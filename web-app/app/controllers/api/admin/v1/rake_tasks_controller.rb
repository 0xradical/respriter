module Api
  module Admin
    module V1

      class RakeTasksController < ActionController::API

        prepend_before_action :authenticate_admin_account!
        before_action :load_dispatcher

        def index
          render json: { data: @dispatcher.tasks }
        end

        def run
          system_call = @dispatcher.dispatch!(rake_task[:command])
          render json: { data: "[#{system_call.arguments[0]}] -> dispatched to job id [#{system_call.job_id}]" }
          rescue ArgumentError => e
            render json: { data: e.message.strip }
        end

        protected

        def load_dispatcher
          @dispatcher = RakeTaskDispatcher.new('system|sitemap|elasticsearch')
        end

        def rake_task
          params.require(:rake_task).permit(:command)
        end

      end

    end
  end
end
