class CoursesController < ApplicationController
  include CourseSearchHelper

  # TODO: Refactor interface names and queries
  def index
    respond_to do |format|
      format.html
      format.json do
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

        render json: format_aggregations(tracker.tracked_results)
      end
    end
  end

  def show
    @course = Course.find_by(slug: params[:slug])
  end
end
