# frozen_string_literal: true

class CoursesController < ApplicationController
  include CourseSearchHelper

  prepend_before_action :normalize_params

  # TODO: Refactor interface names and queries
  def index
    @courses = search

    respond_to do |format|
      format.html
      format.json do
        render json: @courses
      end
    end
  end

  def show
    @provider = Provider.slugged.find_by!(slug: params[:provider])
    @course   = @provider.courses.published.find_by(slug: params[:course])

    if @course
      response.set_header('X-Robots-Tag', 'noindex') unless @course.indexable_by_robots?
    end

    unless @course
      redirected_course = Course
                          .published
                          .joins(:slug_histories)
                          .where('provider_id = ? AND slug_histories.slug = ?', @provider.id, params[:course])
                          .first

      if redirected_course.present?
        redirect_to "/#{params[:provider]}/courses/#{redirected_course.slug}", status: 301
        return
      end

      outdated_course = @provider
                        .courses
                        .where('up_to_date_id IS NOT NULL')
                        .find_by(slug: params[:course])

      if outdated_course.present?
        up_to_date_course = Course.find_by id: outdated_course.up_to_date_id
        redirect_to "/#{params[:provider]}/courses/#{up_to_date_course.slug}", status: 301
        return
      end
    end

    raise ActiveRecord::RecordNotFound unless @course
  end

  protected

  def enhance_search_query_params(search_query_params)
    search_query_params[:filter] ||= {}
    search_query_params[:filter][:curated_tags] = [@tag] if @tag
    search_query_params[:filter][:provider_name] = [@provider.name] if @provider

    if search_query_params[:order].present?
      search_query_params[:order] = search_query_params[:order].to_h.to_a
    end

    search_query_params
  end

  def search
    search_query_params = {
      query:      search_params[:q],
      filter:     search_params[:filter],
      page:       search_params[:p],
      session_id: session_tracker.session_payload['id'],
      boost:      {
        browser_languages: browser_languages
      }
    }

    search  = Search::CourseSearch.new(enhance_search_query_params(search_query_params))
    tracker = SearchTracker.new(session_tracker, search, action: :course_search).store!

    format_aggregations(tracker.tracked_results)
  end

  def normalize_params
    @tag = params[:tag]&.downcase&.underscore
  end
end
