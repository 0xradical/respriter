# frozen_string_literal: true

class ProvidersController < ApplicationController
  def show
    @provider = Provider.slugged.find_by(slug: params[:provider])
    @courses = @provider.recommended_courses(I18n.locale, 12)
    @course_count = @provider.courses.published.count
    @instructors = @provider.instructors.limit(12)
    @instructor_count = @provider.instructors.count
    @posts = @provider.posts.published.locale(I18n.locale).limit(3)
    @details = {}
    @stats = {}

    areas_of_knowledge = @provider.areas_of_knowledge
    membership_types = @provider.membership_types
    price_range = @provider.price_range
    has_trial = @provider.has_trial?
    top_countries = @provider.top_countries

    @details[:areas_of_knowledge] = areas_of_knowledge.presence if areas_of_knowledge.presence
    @details[:membership_types] = membership_types if membership_types.compact.any?
    @details[:price_range] = price_range if price_range.compact.any?
    @details[:has_trial] = has_trial if @details[:price_range]

    @stats[:instructor_count] = @instructor_count if @instructors.any?
    @stats[:course_count] = @provider.courses.published.count if @provider.courses.published.any?
    @stats[:top_countries] = top_countries if top_countries.compact.any?
  end
end
