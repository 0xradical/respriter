# frozen_string_literal: true

class ProvidersController < ApplicationController
  def show
    @provider    = Provider.slugged.find_by(slug: params[:provider])
    @courses     = @provider.recommended_courses(I18n.locale, 12)
    @instructors = @provider.instructors.limit(12)
    @posts       = @provider.posts.published.locale(I18n.locale).limit(3)
    @details     = {}
    @stats       = {}

    @provider_stats   = @provider.provider_stats
    @provider_pricing = @provider.provider_pricing

    course_count       = @provider_stats&.indexed_courses
    instructor_count   = @provider_stats&.instructors
    areas_of_knowledge = @provider_stats&.areas_of_knowledge
    top_countries      = @provider_stats&.top_countries
    membership_types   = @provider_pricing&.membership_types
    price_range        = @provider_pricing&.price_range
    has_trial          = @provider_pricing&.has_trial?

    @details[:areas_of_knowledge] = areas_of_knowledge
    @details[:membership_types]   = membership_types
    @details[:price_range]        = price_range
    @details[:has_trial]          = has_trial

    @stats[:instructor_count]     = instructor_count
    @stats[:course_count]         = course_count
    @stats[:top_countries]        = top_countries
  end
end
