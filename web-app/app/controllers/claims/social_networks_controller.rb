module Claims
  class SocialNetworksController < BaseController

    def update
      orphaned_profile = OrphanedProfile.enabled.find_by!(slug: params[:id])
      claim_method = OauthAccount.find(session[:claim_with])
      if claim_method.present?
        orphaned_profile.send("verify_#{claim_method.provider}_identity!", claim_method.raw_data)
        flash[:notice] = t('.success')
        orphaned_profile.transfer_ownership!(current_user_account)
        redirect_to user_account_path(orphaned_profile.claimed_by)
      else
        flash[:alert] = t('.fail')
        redirect_to claim_orphaned_profile_path(orphaned_profile.slug)
      end
      rescue OrphanedProfile::IdentityMismatchError => e
        flash[:alert] = e.message
        redirect_to claim_orphaned_profile_path(orphaned_profile.slug)
    end

  end
end
