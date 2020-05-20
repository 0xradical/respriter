class OrphanedProfilesController < ApplicationController

  include ActionView::Helpers::DateHelper

  prepend_before_action :load_resource, only: [:show, :claim]
  before_action :authenticate_user_account!, only: [:claim, :email_verification_link]

  def show
    redirect_to user_account_path(@orphaned_profile.claimed_by) and return if
    @orphaned_profile.has_been_successfully_claimed?
  end

  def claim
    if (@orphaned_profile.has_been_successfully_claimed?)
      redirect_to user_account_path(@orphaned_profile.claimed_by)
    else
      if (@orphaned_profile.claimable_emails.include?(current_user_account.email))
        @orphaned_profile.transfer_ownership!(current_user_account)
        flash[:notice] = "#{@orphaned_profile.name} has been successfully claimed"
        redirect_to user_account_path(@orphaned_profile.claimed_by)
      end
    end
    # We don't have permission yet to access the user nickname. Waiting for a feedback
    # from the Linkedin Team https://www.linkedin.com/developers/apps/52605104/products?view=requests
    @claimable_public_profiles = @orphaned_profile.claimable_public_profiles.reject { |k,v|  k == 'linkedin' }
  end

  def send_verification_link
    @orphaned_profile = OrphanedProfile.find(params[:id])
    if @orphaned_profile.claimable_emails.include?(params[:email])
      @orphaned_profile.generate_claim_code!
      flash[:notice] = t('.success', email: params[:email], time: distance_of_time_in_words(Time.now, @orphaned_profile.claim_code_expires_at))
      OrphanedProfileMailer.build(@orphaned_profile, params[:email], I18n.locale).deliver_later
      redirect_to orphaned_profile_path(@orphaned_profile.slug)
    else
      flash[:alert] = t('fail', email: params[:email])
      redirect_to claim_orphaned_profile_path(@orphaned_profile.slug)
    end
  end

  protected

  def load_resource
    @orphaned_profile = OrphanedProfile.enabled.find_by!(slug: params[:id])
  end

end
