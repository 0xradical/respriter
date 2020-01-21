class OrphanedProfilesController < ApplicationController

  def show
    @orphaned_profile = OrphanedProfile.enabled.find_by!(slug: params[:id])
  end

end
