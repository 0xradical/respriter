module Search
  class CourseSearch
    VERSION = '1.1.1'
    PER_PAGE = 20

    attr_reader :query, :filter, :page, :per_page, :order, :boost, :session_id

    FILTER_BY_FIELD = {
      root_audio:        :term,
      subtitles:         :term,
      category:          :term,
      tags:              :term,
      provider_name:     :term,
      curated_tags:      :term,
      curated_root_tags: :term,
      refinement_tags:   :term,
      price:             :range,
      paid_content:      :paid_content
    }
    TERM_AGGREGATIONS = FILTER_BY_FIELD.find_all{ |k,v| v == :term }.map &:first

    def initialize(query: nil, filter: Hash.new, page: 1, per_page: PER_PAGE, order: nil, boost: nil, session_id: nil)
      @query      = query
      @filter     = normalize_filter filter
      @page       = ( page     || 1  ).to_i
      @per_page   = ( per_page || PER_PAGE ).to_i
      @order      = order
      @boost      = boost
      @session_id = session_id
    end

    def results
      return @results if @results.present?

      response = Course.__elasticsearch__.search self.to_h
      @results = {
        data: response.results.map(&:_source),
        meta: {
          total:        response.results.total,
          page:         @page,
          pages:        ([response.results.total, 10000].min / @per_page).ceil, # 10000 is the default max window for Elastic Search
          per_page:     @per_page,
          order:        @order,
          max_score:    response.results.max_score,
          aggregations: format_aggregations(response.aggregations)
        }
      }
    end

    def to_h
      main_query = fulltext_query

      if boost.present?
        main_query[:bool][:should].concat boost_queries
      end

      search_query = {
        query:       randomized_query(main_query),
        aggs:        aggregation_query,
        post_filter: filter_query,
        size:        @per_page,
        from:        (@page - 1)*@per_page
      }

      if order.present?
        search_query.merge! sort_query
      end

      search_query
    end
    alias :to_hash :to_h

    protected
    def normalize_filter(filter)
      return Hash.new if filter.blank?

      FILTER_BY_FIELD.map do |key, type|
        next unless filter.has_key?(key)

        value = filter[key]
        case type
        when :term
          [
            key,
            ( value.is_a?(Array) ? value : [ value ] )
          ]
        when :range
          [
            key,
            ( value.is_a?(Array) ? value : [ 0, value ] )
          ]
        when :paid_content
          [ key, value ]
        else
          STDERR.puts "Unrecognized key #{key}"
        end
      end.compact.to_h
    end

    def randomized_query(query)
      return query if @session_id.blank?

      {
        function_score: {
          query: query,
          functions: [
            {
              random_score: {
                seed: @session_id
              },
              weight: 0.5
            }
          ],
          score_mode: 'sum',
        }
      }
    end

    def fulltext_query
      text_query   = nil
      should_query = [
        {
          term: {
            from_index_tool: {
              value: true,
              boost: 1.5
            }
          }
        }
      ]

      if @query.blank?
        text_query = { match_all: Hash.new }
      else
        text_query = {
          multi_match: {
            query: @query,
            type: 'cross_fields',
            operator: 'and',
            fields: [
              'name.en^2', 'description.en', 'tags_text.en^2', 'instructors_text.en', 'provider_name_text.en',
              'name.br^2', 'description.br', 'tags_text.br^2', 'instructors_text.br', 'provider_name_text.br',
              'name.es^2', 'description.es', 'tags_text.es^2', 'instructors_text.es', 'provider_name_text.es',
            ]
          }
        }

        should_query << {
          multi_match: {
            query: @query,
            fields: [
              'category_text.en',
              'category_text.br',
              'category_text.es',
            ]
          }
        }
      end

      {
        bool: {
          must:   text_query,
          should: should_query
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
      unselected_aggregation_options = { field: key }.merge unselected_aggregation_options_for_field(key)

      if filters_by_key[key].blank?
        return {
          unselected: {
            filter: { match_all: {} },
            aggs: {
              _: { terms: unselected_aggregation_options }
            }
          }
        }
      end

      {
        selected: {
          filter: filters_by_key[key],
          aggs: {
            _: { terms: { field: key, size: 100 } }
          }
        },
        unselected: {
          filter: must_not_filter(filters_by_key[key]),
          aggs: {
            _: { terms: unselected_aggregation_options }
          }
        }
      }
    end

    def unselected_aggregation_options_for_field(key)
      case key
      when :category
        { size: 15 }
      when :provider_name
        { size: 50 }
      else
        Hash.new
      end
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
      selected_buckets   = format_buckets aggregation.selected&._&.buckets
      unselected_buckets = format_buckets aggregation.unselected&._&.buckets

      selected_keys   = (@filter[key] || []).map(&:to_sym)
      missing_keys    = selected_keys - selected_buckets.map(&:first)
      unselected_keys = selected_buckets.find_all{ |k, c| !selected_keys.include?(k) }.to_h

      selected_buckets = selected_buckets.find_all{ |k, c| selected_keys.include?(k) }
      selected_buckets.concat( missing_keys.map{ |k| [k, 0] } )

      unselected_buckets = unselected_buckets.map do |key, count|
        if unselected_keys[key]
          [ key, count + unselected_keys[key] ]
        else
          [ key, count ]
        end
      end

      {
        selected:   selected_buckets.find_all{ |k, c| selected_keys.include?(k) },
        unselected: unselected_buckets.sort_by(&:last).reverse
      }
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
            raise InvalidFilterError.new("Invalid query value #{v} at #{key} filter")
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
        raise InvalidFilterError.new("Invalid query filter #{key}")
      end
    end

    class SearchBadRequest < ActionController::BadRequest
    end

    class InvalidFilterError < SearchBadRequest
    end

    class InvalidFilterValueError < SearchBadRequest
    end
  end
end
