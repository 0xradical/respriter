class InstructorsController < ApplicationController

  def index
    instructors = OrphanedProfile.enabled

    if params[:teaching_subjects].present?
      instructors = instructors.teaching_subjects(params[:teaching_subjects])
    end

    @instructors = instructors.order('name ASC').page(params[:page]).per(120)
  end

end
