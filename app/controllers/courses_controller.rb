class CoursesController < ApplicationController
  # TODO: Refactor interface names and queries
  def index
    respond_to do |format|
      format.html
      format.json do
        search_query_params = {
          query:  search_params[:q],
          filter: search_params[:filter],
          page:   search_params[:p],
          boost: {
            browser_languages: browser_languages
          }
        }

        if search_params[:order].present?
          search_query_params[:order] = search_params[:order].to_h.to_a
        end

        search  = Search::CourseSearch.new search_query_params
        tracker = SearchTracker.new(session_tracker, search).store!

        render json: format_aggregations(tracker.tracked_results)
      end
    end
  end

  protected
  def format_aggregations(results)
    aggregations = results[:meta][:aggregations]

    formatted_aggregations = {
      root_audio: {
        buckets: format_bucket(:root_audio, aggregations[:root_audio])
      },
      subtitles: {
        buckets: format_bucket(:subtitles, aggregations[:subtitles])
      },
      provider_name: {
        buckets: format_bucket(:provider_name, aggregations[:provider_name])
      },
      min_price: {
        value: aggregations[:min_price]
      },
      max_price: {
        value: aggregations[:max_price]
      },
      category: {
        buckets: format_bucket(:category, aggregations[:category])
      }
    }

    results.deep_merge meta: { aggregations: formatted_aggregations }
  end

  def format_bucket(key, aggregation)
    [
      *aggregation[:selected],
      *aggregation[:unselected]
    ].map do |k, v|
      { key: k, doc_count: v }
    end
  end

  def search_params
    params.permit(:q, :p, order: {}, filter: {})
  end

  def browser_languages
    return [] if request.headers['HTTP_ACCEPT_LANGUAGE'].blank?

    HTTP::Accept::Languages.parse(request.headers['HTTP_ACCEPT_LANGUAGE']).map(&:locale) - ['*']
  end
end
