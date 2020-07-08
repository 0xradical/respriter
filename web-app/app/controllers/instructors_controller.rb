# frozen_string_literal: true

class InstructorsController < ApplicationController
  def index
    instructors = if instructors_params[:provider].present?
                    @provider = Provider.slugged.find_by(slug: instructors_params[:provider])
                    @provider&.instructors || OrphanedProfile.none
                  else
                    OrphanedProfile.enabled
                  end

    if instructors_params[:teaching_subjects]
      instructors = instructors.teaching_subjects(instructors_params[:teaching_subjects])
    elsif instructors_params[:teaching_at]
      instructors = instructors.teaching_at(instructors_params[:teaching_at])
    end

    @instructors = instructors.order('name ASC').page(instructors_params[:page]).per(120)
  end

  protected

  def instructors_params
    params.permit(:teaching_at, :teaching_subjects, :page, :provider)
  end
end
