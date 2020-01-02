class OrphanedProfilesController < ApplicationController

  def show
    @orphaned_profile = OrphanedProfile.find_by(slug: params[:id])
    @courses = Course.published.first(12)
  end

end
