class Course < ApplicationRecord

  include Elasticsearch::Model
  #include Elasticsearch::Model::Callbacks
  include Slugifyable

  paginates_per 25

  slugify run_on: :before_save

  validates :name, presence: true

  belongs_to  :provider
  has_many    :user_accounts, through: :enrollments

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do

      indexes :name, type: 'text' do
        indexes :en, analyzer: 'english'
        indexes :br, analyzer: 'brazilian'
        indexes :es, analyzer: 'spanish'
      end

      indexes :description, type: 'text' do
        indexes :en, analyzer: 'english'
        indexes :br, analyzer: 'brazilian'
        indexes :es, analyzer: 'spanish'
      end

      indexes :price,     type: 'double'
      indexes :audio,     type: 'keyword'
      indexes :subtitles, type: 'keyword'
      indexes :category,  type: 'keyword'

    end
  end

  scope :by_category, -> (category) { where(category: category) }
  scope :by_provider, -> (provider) { joins(:provider).where("providers.slug = ?", provider)  }
  scope :free, -> { where(price: 0) }

  def affiliate_link
    if provider.afn_url_template.present?
      provider.afn_url_template % { course_url: ERB::Util.url_encode(url) }
    else
      url
    end
  end

  class << self

    def bulk_upsert(values)
      result = import values, validate: false, on_duplicate_key_update: {
        conflict_target: [:global_id], columns: [:duration_in_hours, :name] 
      }
      bulk_index_async(result.ids)
    end

    def search(query)
      __elasticsearch__.search(query)
    end

    def search(q, options={})
      search_def = Elasticsearch::DSL::Search.search do
        query do

          bool do
            must do

              if q.present?
                multi_match do
                  query q
                  type 'best_fields'
                  fields %w(name description provider.name)
                end
              else
                match_all
              end

            end
          end
        end

        post_filter do
          bool do

            if options[:category]
              must { terms category: options[:category] }
            end

            if options[:audio]
              must { terms audio: options[:audio] }
            end

            if options[:subtitles]
              must { terms subtitles: options[:subtitles] }
            end

            if options[:price]
              must do 
                range price: { lte: options[:price] }
              end
            end

          end
        end

        aggregation :audios do
          terms do
            field 'audio'
          end
        end

        aggregation :subtitles do
          terms do
            field 'subtitles'
          end
        end

        aggregation :categories do
          terms do
            field 'category'
          end
        end

        aggregation :max_price do
          max field: 'price'
        end


      end
      __elasticsearch__.search(search_def)
    end

    def elasticsearch_import
      __elasticsearch__.import
    end

    def bulk_index_async(records)
      ElasticSearchIndexJob.perform_later(self.to_s, records)
    end

  end

  def as_indexed_json(options={})
    self.as_json(methods: :affiliate_link, include: { provider: { only: [:name, :slug] } })
  end

end
