class Course < ApplicationRecord

  include CSVImport
  include Elasticsearch::Model
  #include Elasticsearch::Model::Callbacks

  SUPPORTED_LANGUAGES = %w(pt en es ru it de fr)

  paginates_per 25

  belongs_to  :provider, optional: true

  has_many    :enrollments
  has_many    :user_accounts, through: :enrollments

  delegate :name, :slug, to: :provider, prefix: true

  index_name "courses_#{Rails.env}" unless Rails.env.production?

  index_config = {
    number_of_shards:   1,
    number_of_replicas: 0,
    analysis: {
      filter: {
        programming_synonyms: {
          type: 'synonym',
          lenient: false,
          synonyms: [
            '@formula, at formula, atformula',
            'a# => asharp',
            'a sharp => asharp',
            'a+ => aplus',
            'a plus => aplus',
            'a plus plus => aplusplus',
            'a++ => aplusplus',
            'c sharp => csharp',
            'c# => csharp',
            'c star => cstar',
            'c* => cstar',
            'c plus plus => cplusplus',
            'c++ => cplusplus',
            'c minus minus => cminusminus',
            'c-- => cminusminus',
            'c/alc al, cal',
            'f# => fsharp',
            'f sharp => fsharp',
            'f star => fstar',
            'f* => fstar',
            'hal/s, hal s, hals',
            'j sharp => jsharp',
            'j# => jsharp',
            'f plus plus => fplusplus',
            'j++ => fplusplus',
            'lc-3, lc 3, lc3',
            'lite-c, lite c, litec',
            'mad/i, mad i, madi',
            'objective-c => objectivec',
            'objective-j => objectivej',
            'objective c => objectivec',
            'objective j => objectivej',
            'pl-11, pl 11, pl11',
            'pl/0, pl 0, pl0',
            'pl/b, pl b, plb',
            'pl/c, pl c, plc',
            'pl/i, pl i, pli',
            'pl/m, pl m, plm',
            'pl/p, pl p, plp',
            'pl/sql, pl sql, plsql',
            'pgplsql, pg pl sql, pgplsql',
            'pro*c, proc',
            'pro star c => proc',
            'rtl/2, rtl 2, rtl2',
            'java virtual machine, jvm',
            'postscript, post script',
            'javascript, js, java script',
            'node.js, node js, nodejs',
            'ruby on rails, ror'
          ]
        },
        english_stemmer: {
          type: 'stemmer',
          language: 'english'
        },
        brazilian_stemmer: {
          type: 'stemmer',
          language: 'brazilian'
        },
        spanish_stemmer: {
          type: 'stemmer',
          language: 'spanish'
        }
      },
      analyzer: {
        english_programmer: {
          tokenizer:   'whitespace',
          filter:      ['lowercase', 'programming_synonyms', 'english_stemmer'],
          char_filter: ['html_strip']
        },
        brazilian_programmer: {
          tokenizer:   'whitespace',
          filter:      ['lowercase', 'programming_synonyms', 'brazilian_stemmer'],
          char_filter: ['html_strip']
        },
        spanish_programmer: {
          tokenizer:   'whitespace',
          filter:      ['lowercase', 'programming_synonyms', 'spanish_stemmer'],
          char_filter: ['html_strip']
        }
      }
    }
  }

  settings index: index_config do
    mappings dynamic: 'false' do

      indexes :name, type: 'text', analyzer: 'english_programmer' do
        indexes :en, analyzer: 'english_programmer'
        indexes :br, analyzer: 'brazilian_programmer'
        indexes :es, analyzer: 'spanish_programmer'
      end

      indexes :description, type: 'text', analyzer: 'english_programmer' do
        indexes :en, analyzer: 'english_programmer'
        indexes :br, analyzer: 'brazilian_programmer'
        indexes :es, analyzer: 'spanish_programmer'
      end

      indexes :syllabus_markdown, type: 'text', analyzer: 'english_programmer' do
        indexes :en, analyzer: 'english_programmer'
        indexes :br, analyzer: 'brazilian_programmer'
        indexes :es, analyzer: 'spanish_programmer'
      end

      indexes :pace,                type: 'keyword'
      indexes :price,               type: 'double'
      indexes :effort,              type: 'integer'
      indexes :free_content,        type: 'boolean'
      indexes :paid_content,        type: 'boolean'
      indexes :subscription_type,   type: 'boolean'
      indexes :has_free_trial,      type: 'boolean'
      indexes :audio,               type: 'keyword'
      indexes :root_audio,          type: 'keyword'
      indexes :subtitles,           type: 'keyword'
      indexes :root_subtitles,      type: 'keyword'
      indexes :offered_by,          type: 'object'
      indexes :instructors,         type: 'object'
      indexes :category,            type: 'keyword'
      indexes :certificate,         type: 'object'
      indexes :level,               type: 'keyword'
      indexes :tags,                type: 'keyword'
      indexes :provider_name,       type: 'keyword'
      indexes :provider_slug,       type: 'keyword'
      indexes :trial_period,        type: 'object'
      indexes :subscription_period, type: 'object'
      indexes :video,               type: 'object'
    end
  end

  scope :by_category,   -> (category) { where(category: category) }
  scope :by_provider,   -> (provider) { joins(:provider).where("providers.slug = ?", provider)  }
  scope :free,          -> { where(free_content: true) }
  scope :featured,      -> { order('enrollments_count DESC') }
  scope :locales,       -> (l) { where("audio @> ?", "{#{l.join(',')}}") }

  def root_languages_for_audio
    audio.map { |lang| lang.split('-')[0] }.uniq
  rescue
    []
  end

  def root_languages_for_subtitles
    subtitles.map { |lang| lang.split('-')[0] }.uniq
  rescue
    []
  end

  def video_thumbnail
    return nil unless video['thumbnail_url']
    crypto = Thumbor::CryptoURL.new ENV.fetch('THUMBOR_SECURITY_KEY')
    path = crypto.generate(:width => 241, :image => CGI.escape(video['thumbnail_url']))
    ENV.fetch('THUMBOR_HOST').chomp('/') + path
  end

  def subscription_type?
    main_pricing_model.try(:[], 'type') == 'subscription'
  end

  def has_free_trial?
    !main_pricing_model.try(:[], 'trial_period')&.empty?
  end

  def price
    (main_pricing_model.try(:[],'price') || super).to_f
  end

  def main_pricing_model
    pricing_models.first
  end

  def trial_period
    main_pricing_model.try(:[], 'trial_period')
  end

  def subscription_period
    main_pricing_model.try(:[], 'subscription_period')
  end

  def has_afn?
    !!provider.afn_url_template
  end

  def forwarding_url(click_id)
    (provider.afn_url_template || url ) % {
      click_id: click_id,
      course_url: provider.encoded_deep_linking? ? ERB::Util.url_encode(url) : url
    }
  end

  def gateway_path
    Rails.application.routes.url_helpers.gateway_path(id)
  end

  def as_indexed_json(options={})
    indexed_json = {
      id:                  id,
      name:                name,
      description:         description,
      price:               price,
      url:                 url,
      pace:                pace,
      effort:              effort,
      gateway_path:        gateway_path,
      offered_by:          offered_by || [],
      instructors:         instructors || [],
      free_content:        free_content?,
      paid_content:        paid_content?,
      subscription_type:   subscription_type?,
      trial_period:        trial_period,
      subscription_period: subscription_period,
      has_free_trial:      has_free_trial?,
      url_id:              url_md5,
      level:               level,
      video_url:           nil,
      video:               (video && video.merge(thumbnail_url: video_thumbnail)),
      tags:                tags,
      audio:               audio,
      root_audio:          root_languages_for_audio,
      subtitles:           subtitles,
      root_subtitles:      root_languages_for_subtitles,
      category:            category,
      provider_name:       provider_name,
      provider_slug:       provider_slug,
      syllabus_markdown:   syllabus,
    }

    if certificate.present?
      indexed_json[:certificate] = {
        type:     certificate[:type],
        price:    certificate[:price],
        currency: certificate[:currency],
      }
    end

    indexed_json
  end

  class << self

    def bulk_upsert(values)
      result = import values, validate: false, on_duplicate_key_update: {
        conflict_target: [:global_id], columns: [:duration_in_hours, :name]
      }
      bulk_index_async(result.ids)
    end

    def current_global_sequence
      maximum(:global_sequence)
    end

    def is_language_supported?(lang)
      !(SUPPORTED_LANGUAGES & [lang].flatten.map { |l| l.split('-') }.flatten).empty?
    end

    def reset_index!
      __elasticsearch__.delete_index! rescue nil
      __elasticsearch__.create_index!
    end

    def reindex!
      reset_index!
      default_import_to_search_index
    end

    def search(query:, filter: nil, order: nil)
      search_exp = Elasticsearch::DSL::Search.search do

        query do
          bool do

            if query.present?

              must do
                multi_match do
                  query query
                  fields %w(name^2 tags.keyword^2 description)
                end
              end

              should do
                term 'tags.keyword' => query
              end

            else

              must do
                match_all
              end

            end

            if (filter&.[] :price)
              filter do
                range price: { gte: filter[:price].min, lte: filter[:price].max }
              end
            end

          end
        end

        post_filter do
          bool do

            if (filter&.[] :providers)
              must { terms provider_name: filter[:providers] }
            end

            if (filter&.[] :categories)
              must { term category: [filter[:categories]].flatten&.first&.gsub('-','_') }
            end

            if (filter&.[] :audio)
              must { terms audio: filter[:audio] }
            end

            if (filter&.[] :subtitles)
              must { terms subtitles: filter[:subtitles] }
            end

          end
        end

        if order&.[] :price
          sort do
            by :price, order: order[:price]
          end
        end

        aggregation :providers do
          terms do
            field 'provider_name'
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
      __elasticsearch__.search(search_exp)
    def default_import_to_search_index
      import_to_search_index({published: true})
    end

    def bulk_index_async(records)
      ElasticSearchIndexJob.perform_later(self.to_s, records)
    end

    private

    def import_to_search_index(scope = nil)
      __elasticsearch__.import query: -> { where(scope).includes(:provider) }
    end

  end
end
