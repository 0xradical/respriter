class InstructorsController < ApplicationController

  def index
    instructors = OrphanedProfile.enabled

    if params[:teaching_subjects]
      instructors = instructors.teaching_subjects(params[:teaching_subjects])
    elsif params[:teaching_at]
      instructors = instructors.teaching_at(params[:teaching_at])
    end

    @instructors = instructors.order('name ASC').page(params[:page]).per(120)
  end

end
