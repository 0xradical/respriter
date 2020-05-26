module Claims
  class CodesController < BaseController

    def verify
      @orphaned_profile = OrphanedProfile.find_by!(claim_code: params[:claim_code])
      if !@orphaned_profile.claim_has_expired?
        @orphaned_profile.transfer_ownership!(current_user_account)
        flash[:notice] = t('.success')
        redirect_to orphaned_profile_path(@orphaned_profile.slug)
      else
        flash[:alert] = t('.fail')
        redirect_to root_path
      end
    end

  end
end
