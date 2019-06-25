module CourseSearchHelper
  extend ActiveSupport::Concern

  included do
    rescue_from Search::CourseSearch::SearchBadRequest, with: :bad_request
  end

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

  def browser_languages
    return [] if request.headers['HTTP_ACCEPT_LANGUAGE'].blank?

    HTTP::Accept::Languages.parse(request.headers['HTTP_ACCEPT_LANGUAGE']).map(&:locale) - ['*']
  end

  def search_params
    params.permit(:q, :p, order: {}, filter: {})
  end

  def bad_request(exception)
    render status: 400, json: { error: exception.message }.to_json
  end
end
