class CoursesController < ApplicationController
  # TODO: Refactor interface names and queries
  def index
    respond_to do |format|
      format.html
      format.json do
        search_query_params = {
          query:  search_params[:q],
          filter: prepare_filter(search_params[:filter]),
          page:   search_params[:p],
          boost: {
            browser_languages: browser_languages
          }
        }

        if search_params[:order].present?
          search_query_params[:order] = search_params[:order].to_h.to_a
        end

        # binding.pry
        results = Search::CourseSearch.new(search_query_params).search

        render json: format_aggregations(results)
      end
    end
  end

  protected
  def format_aggregations(results)
    aggregations = results[:meta][:aggregations]

    formatted_aggregations = {
      audios: {
        buckets: format_bucket(:audio, aggregations[:root_audio])
      },
      subtitles: {
        buckets: format_bucket(:subtitles, aggregations[:subtitles])
      },
      providers: {
        buckets: format_bucket(:providers, aggregations[:provider_name])
      },
      min_price: {
        value: aggregations[:min_price]
      },
      max_price: {
        value: aggregations[:max_price]
      },
      categories: {
        buckets: format_bucket(:categories, aggregations[:category])
      }
    }

    results.deep_merge meta: { aggregations: formatted_aggregations }
  end

  def prepare_filter(filter)
    return Hash.new if filter.blank?
    filters = {
      root_audio:    filter[:audio],
      subtitles:     filter[:subtitles],
      category:      ensure_array_filter_query(filter[:categories]),
      tags:          filter[:tags],
      provider_name: filter[:providers],
      price:         filter[:price],
      paid_content:  filter[:paid_content],
    }

    filters.find_all{ |k,v| v.present? }.to_h
  end

  def ensure_array_filter_query(data)
    if data.is_a?(Array)
      data.uniq.compact
    else
      [ data ].uniq.compact
    end
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
