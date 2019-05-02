module Search
  class CourseSearch
    attr_reader :query, :filter, :page, :per_page, :order, :boost

    FILTER_BY_FIELD = {
      root_audio:    :term,
      subtitles:     :term,
      category:      :term,
      tags:          :term,
      provider_name: :term,
      price:         :range,
      paid_content:  :paid_content
    }
    TERM_AGGREGATIONS = FILTER_BY_FIELD.find_all{ |k,v| v == :term }.map &:first

    def initialize(query: nil, filter: nil, page: 1, per_page: 25, order: nil, boost: nil)
      @query    = query
      @filter   = filter || Hash.new
      @page     = ( page     || 1  ).to_i
      @per_page = ( per_page || 25 ).to_i
      @order    = order
      @boost    = boost
    end

    def search
      response = Course.__elasticsearch__.search self.to_h
      {
        data: response.results.map(&:_source),
        meta: {
          total:        response.results.total,
          page:         @page,
          per_page:     @per_page,
          order:        @order,
          max_score:    response.results.max_score,
          aggregations: format_aggregations(response.aggregations)
        }
      }
    end

    def to_h
      search_query = {
        query:       fulltext_query,
        aggs:        aggregation_query,
        post_filter: filter_query,
        size:        @per_page,
        from:        (page - 1)*@per_page
      }

      if order.present?
        search_query.merge! sort_query
      end

      if boost.present? && search_query[:query][:bool].present?
        search_query[:query][:bool][:should].concat boost_queries
      end

      search_query
    end
    alias :to_hash :to_h

    protected
    def fulltext_query
      return { match_all: Hash.new } if @query.blank?

      {
        bool: {
          must: {
            multi_match: {
              query: @query,
              fields: [ 'name^2', 'tags.keyword^2', 'description' ]
            }
          },
          should: [
            { term: { 'tags.keyword'     => @query } },
            { term: { 'category.keyword' => @query } }
          ]
        }
      }
    end

    def aggregation_query
      terms_aggregation_query.merge price_aggregation_query
    end

    def filter_query
      { bool: { filter: filters_by_key.values } }
    end

    def sort_query
      orderings = @order.map do |key, order|
        { key => { order: order } }
      end
      { sort: orderings }
    end

    def boost_queries
      [
        {
          terms: {
            root_audio: @boost[:browser_languages]
          }
        },
        {
          terms: {
            subtitles: @boost[:browser_languages]
          }
        }
      ]
    end

    def terms_aggregation_query
      TERM_AGGREGATIONS.map do |key|
        [
          key,
          {
            filter: query_filters(except: key),
            aggs:   aggregation_for_field(key)
          }
        ]
      end.to_h
    end

    def aggregation_for_field(key)
      if filters_by_key[key].blank?
        return {
          unselected: {
            filter: { match_all: {} },
            aggs: {
              _: { terms: { field: key } }
            }
          }
        }
      end

      {
        selected: {
          filter: filters_by_key[key],
          aggs: {
            _: { terms: { field: key } }
          }
        },
        unselected: {
          filter: must_not_filter(filters_by_key[key]),
          aggs: {
            _: { terms: { field: key } }
          }
        }
      }
    end

    def price_aggregation_query
      {
        max_price: { max: { field: 'price' } },
        min_price: { min: { field: 'price' } },
        paid_content: {
          filter: query_filters(except: :paid_content),
          aggs: {
            _: {
              filters: {
                filters: {
                  free: {
                    bool: {
                      filter: [
                        { term: { paid_content: false } },
                        { term: { free_content: true  } }
                      ]
                    }
                  },
                  partially_free: {
                    bool: {
                      filter: [
                        { term: { paid_content: true } },
                        { term: { free_content: true } }
                      ]
                    }
                  },
                  paid: {
                    bool: {
                      filter: [
                        { term: { paid_content: true  } },
                        { term: { free_content: false } }
                      ]
                    }
                  }
                }
              }
            }
          }
        },
        price: {
          filter: query_filters(except: :price),
          aggs: {
            _: {
              histogram: {
                field:    'price',
                interval: 10
              }
            }
          }
        }
      }
    end

    def query_filters(except: nil)
      filters = filters_by_key.select do |key, value|
        key != except
      end.values
      { bool: { filter: filters } }
    end

    def must_not_filter(filter)
      { bool: { must_not: filter } }
    end

    def filters_by_key
      @filters_by_key ||= @filter.select do |key, value|
        value.present?
      end.to_h.map do |key, value|
        [
          key.to_sym,
          filter_by_key(key.to_sym, value)
        ]
      end.to_h
    end

    def format_aggregations(aggregations)
      formated_aggregations = FILTER_BY_FIELD.map do |key, kind|
        [
          key,
          send(:"format_aggregation_#{kind}", key, aggregations[key])
        ]
      end.to_h

      formated_aggregations.merge max_price: aggregations[:max_price][:value]
    end

    def format_aggregation_term(key, aggregation)
      {
        selected:   format_selected_buckets(key, aggregation.selected&._&.buckets),
        unselected: format_buckets(aggregation.unselected&._&.buckets)
      }
    end

    def format_selected_buckets(key, buckets)
      formatted_buckets = format_buckets buckets
      return formatted_buckets if @filter[key].blank?

      missing_keys = @filter[key].map(&:to_sym) - formatted_buckets.map(&:first)
      [
        *formatted_buckets,
        *missing_keys.map{ |key| [key, 0] }
      ]
    end

    def format_aggregation_range(key, aggregation)
      format_buckets aggregation&._&.buckets
    end

    def format_aggregation_paid_content(key, aggregation)
      buckets = format_buckets aggregation._.buckets
      selected_keys = @filter[:paid_content] || []
      buckets.group_by do |key, count|
        if selected_keys.include?(key)
          :selected
        else
          :unselected
        end
      end.map do |key, values|
        [
          key,
          values.to_h
        ]
      end
    end

    def format_buckets(buckets)
      return [] if buckets.blank?

      if buckets.is_a?(Hash)
        buckets.map do |key, value|
          [
            key.to_s.to_sym,
            value[:doc_count]
          ]
        end
      else
        buckets.map do |bucket|
          [
            bucket[:key].to_s.to_sym,
            bucket[:doc_count]
          ]
        end
      end
    end

    def filter_by_key(key, value)
      case FILTER_BY_FIELD[key]
      when :term
        { terms: { key => value } }
      when :range
        {
          range: {
            key => [:gte, :lte].zip(value).to_h
          }
        }
      when :paid_content
        paid_content = []
        free_content = []

        value.each do |v|
          case v.to_sym
          when :free
            paid_content << false
            free_content << true
          when :paid
            paid_content << true
            free_content << false
          when :partially_free
            paid_content << true
            free_content << true
          else
            raise 'Something went wrong'
          end
        end

        {
          bool: {
            filter: [
              {
                terms: {
                  free_content: free_content.uniq
                }
              },
              {
                terms: {
                  paid_content: paid_content.uniq
                }
              }
            ]
          }
        }
      else
        raise 'Something went wrong'
      end
    end
  end
end
