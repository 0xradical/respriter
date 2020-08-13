# frozen_string_literal: true

class GatewayController < ApplicationController
  before_action do
    @click_id = SecureRandom.uuid
    @waiting_time_in_seconds = ENV.fetch('GATEWAY__WAITING_TIME_IN_SECONDS') { 2.2 }

    # params[:id] is here to keep compatibility
    # with old /:id interface used only for courses
    # assume course if params[:to] is an uuid
    if params[:id] || UUID.uuid?(params[:to])
      @course          = Course.find(params[:id] || params[:to])
      @provider        = @course.provider
      @scope           = @course.enrollments
      @forwarding_url  = @provider.forwarding_url(@course.url, click_id: @click_id)
    # otherwise :to is an url
    else
      # params[:pid] is provider
      if params[:pid].present? && (
        @provider = UUID.uuid?(params[:pid]) ?
          Provider.find_by(id: params[:pid]) :
          Provider.find_by(slug: params[:pid])
      )
        @scope          = @provider.enrollments
        @forwarding_url = @provider.forwarding_url(params[:to].presence, click_id: @click_id)
      else
        @scope          = Enrollment
        @forwarding_url = params[:to].presence
      end
    end
  end

  def index
    # if Browser.new(request.env['HTTP_USER_AGENT']).bot?
      # render 'block_bots', status: 400, layout: false
      # if Rails.env.production?
        # Raven.send_event(
          # level:       'error',
          # message:     "Blocked Bot at Gateway by user agent: #{request.env['HTTP_USER_AGENT']}",
          # environment: 'production'
        # )
      # end
      # return
    # end
    if @scope && @forwarding_url
      @scope.create!({
                       id:                @click_id,
                       tracked_url:       @forwarding_url,
                       tracking_data:     session_tracker.session_payload,
                       tracking_cookies:  session_tracker.cookies_payload,
                       tracked_search_id: params[:sid],
                       user_account_id:   current_user_account&.id
                     })

      redirect_to @forwarding_url if page_version[:version].blank?
    end
  end
end
