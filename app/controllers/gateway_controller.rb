class GatewayController < ApplicationController

  def index
    if Browser.new(request.env['HTTP_USER_AGENT']).bot?
      render 'block_bots', status: 400, layout: false
      if Rails.env.production?
        Raven.send_event(
          level:       'error',
          message:     "Blocked Bot at Gateway by user agent: #{request.env['HTTP_USER_AGENT']}",
          environment: 'production'
        )
      end
      return
    end

    click_id       = SecureRandom.uuid
    course         = Course.find(params[:id])
    forwarding_url = course.forwarding_url(click_id)
    enrollment     = course.enrollments.create!({
      id:                click_id,
      tracked_url:       forwarding_url,
      tracking_data:     session_tracker.session_payload,
      tracking_cookies:  session_tracker.cookies_payload,
      tracked_search_id: params[:sid],
      user_account_id:   current_user_account&.id
    })
    redirect_to forwarding_url
  end

end
