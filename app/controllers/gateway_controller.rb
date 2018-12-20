class GatewayController < ApplicationController

  def index
    click_id        = SecureRandom.uuid
    course          = Course.find(params[:id])
    forwarding_url  = course.forwarding_url(click_id)
    enrollment      = course.enrollments.create!({
      id:               click_id,
      tracked_url:      forwarding_url,
      tracking_data:    session[:tracking_data],
      user_account_id:  current_user_account&.id
    })
    redirect_to forwarding_url
  end

end
