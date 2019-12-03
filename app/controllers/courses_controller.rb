class CoursesController < ApplicationController
  include CourseSearchHelper

  # TODO: Refactor interface names and queries
  def index
    respond_to do |format|
      format.html do
        @courses = search()
      end

      format.json do
        render json: search()
      end
    end
  end

  def show
    @provider = Provider.find_by!(slug: params[:provider])
    @course   = @provider.courses.published.find_by!(slug: params[:course])
  end

  protected

  def search
    search_query_params = {
      query:      search_params[:q],
      filter:     search_params[:filter],
      page:       search_params[:p],
      session_id: session_tracker.session_payload[:id],
      boost: {
        browser_languages: browser_languages
      }
    }

    if search_params[:order].present?
      search_query_params[:order] = search_params[:order].to_h.to_a
    end

    search  = Search::CourseSearch.new search_query_params
    tracker = SearchTracker.new(session_tracker, search, action: :course_search).store!

    format_aggregations(tracker.tracked_results)
  end
end
