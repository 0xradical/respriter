class CourseBundlesController < ApplicationController
  include CourseSearchHelper

  prepend_before_action :normalize_params

  def index
    bundles = Course.unnest_curated_tags(Course.by_tags(@tag)).group(:tag).count
    RootTag.all.each{ |rt| bundles.delete rt.id }

    @bundles_by_letter = bundles.map do |k,v|
      [
        t("tags.#{k}"),
        { tag: k, count: v }
      ]
    end.to_h.group_by{ |k,v| k[0] }.sort.map{ |k,v| Hash[v] }
  end

  def show
    respond_to do |format|
      format.html do
        search = Search::CourseSearch.new search_query_params.merge(per_page: 0)
        @root_tags = search.results[:meta][:aggregations][:curated_root_tags].values.map do |results|
          results.map &:first
        end.flatten.compact.uniq.map &:to_s
      end

      format.json do
        search_query_params[:per_page] ||= 75
        search  = Search::CourseSearch.new search_query_params
        tracker = SearchTracker.new(session_tracker, search, action: :course_bundle_search).store!

        render json: format_aggregations(tracker.tracked_results)
      end
    end
  end

  protected
  def search_query_params
    @search_query_params ||= {
      query:      search_params[:q],
      filter:     (search_params[:filter] || Hash.new).merge(curated_tags: [@tag]),
      page:       search_params[:p],
      session_id: session_tracker.session_payload[:id],
      boost: {
        browser_languages: browser_languages
      }
    }
  end

  def normalize_params
    @tag = params[:tag]&.downcase.underscore
  end
end
