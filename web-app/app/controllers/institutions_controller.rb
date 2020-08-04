# frozen_string_literal: true

class InstitutionsController < ApplicationController
  def show
    @institution = Institution.new
    @courses     = @institution.courses
    @instructors = @institution.instructors
    @posts       = @institution.posts
    @details     = {}
    @stats       = {}

    @institution_stats   = @institution.institution_stats
    @institution_pricing = @institution.institution_pricing

    course_count       = @institution_stats&.indexed_courses
    instructor_count   = @institution_stats&.instructors
    areas_of_knowledge = @institution_stats&.areas_of_knowledge
    top_countries      = @institution_stats&.top_countries
    membership_types   = @institution_pricing&.membership_types
    price_range        = @institution_pricing&.price_range
    has_trial          = @institution_pricing&.has_trial?

    @details[:areas_of_knowledge] = areas_of_knowledge
    @details[:membership_types]   = membership_types
    @details[:price_range]        = price_range
    @details[:has_trial]          = has_trial

    @stats[:instructor_count]     = instructor_count
    @stats[:course_count]         = course_count
    @stats[:top_countries]        = top_countries
  end
end
