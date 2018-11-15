class GatewayController < ApplicationController

  prepend_before_action :authenticate_user_account!

  def index
    click_id        = SecureRandom.uuid
    course          = Course.find(params[:id])
    forwarding_url  = course.forwarding_url(click_id)
    enrollment      = course.enrollments.create!({
      click_id:         click_id,
      tracked_url:      forwarding_url,
      user_account_id:  current_user_account&.id
    })
    redirect_to forwarding_url
    # rescue 
      # redirect_to root_path
  end

end
