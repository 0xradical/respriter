class OrphanedProfilesController < ApplicationController

  def show
    @orphaned_profile = OrphanedProfile.find_by(slug: params[:id])
  end

end
