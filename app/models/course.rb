class Course < ApplicationRecord
  include CSVImport
  include Elasticsearch::Model
  #include Elasticsearch::Model::Callbacks

  SUPPORTED_LANGUAGES = %w[pt en es ru it de fr]
  SITE_LOCALES = { br: 'pt-BR', en: 'en' }
  SIMILAR_COURSES = 15

  paginates_per 50

  belongs_to :provider, optional: true

  has_many :enrollments
  has_many :slug_histories
  has_many :user_accounts, through: :enrollments

  delegate :name, :slug, to: :provider, prefix: true

  index_name "courses_#{Rails.env}" unless Rails.env.production?

  index_config = {
    number_of_shards: 1,
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
            'big data, bigdata',
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
            'ruby on rails, ror',
            'angular.js, angular js, angularjs, angular',
            'react.js, react js, reactjs, react',
            'vue.js, vue js, vuejs, vue'
          ]
        },
        english_stemmer: { type: 'stemmer', language: 'english' },
        brazilian_stemmer: { type: 'stemmer', language: 'brazilian' },
        spanish_stemmer: { type: 'stemmer', language: 'spanish' },
        all_stopwords: {
          type: 'stop', stopwords: %w[_english_ _portuguese_ _spanish_]
        },
        english_stopwords: { type: 'stop', stopwords: '_english_' },
        portuguese_stopwords: { type: 'stop', stopwords: '_portuguese_' },
        spanish_stopwords: { type: 'stop', stopwords: '_spanish_' }
      },
      analyzer: {
        english_programmer: {
          tokenizer: 'whitespace',
          filter: %w[
            lowercase
            programming_synonyms
            all_stopwords
            english_stemmer
          ],
          char_filter: %w[html_strip]
        },
        brazilian_programmer: {
          tokenizer: 'whitespace',
          filter: %w[
            lowercase
            programming_synonyms
            all_stopwords
            brazilian_stemmer
          ],
          char_filter: %w[html_strip]
        },
        spanish_programmer: {
          tokenizer: 'whitespace',
          filter: %w[
            lowercase
            programming_synonyms
            all_stopwords
            spanish_stemmer
          ],
          char_filter: %w[html_strip]
        },
        proper_names: {
          tokenizer: 'whitespace',
          filter: %w[
            lowercase
            programming_synonyms
            all_stopwords
          ],
          char_filter: %w[html_strip]
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

      indexes :syllabus_markdown,
              type: 'text', analyzer: 'english_programmer' do
        indexes :en, analyzer: 'english_programmer'
        indexes :br, analyzer: 'brazilian_programmer'
        indexes :es, analyzer: 'spanish_programmer'
      end

      indexes :category_text do
        indexes :en, type: 'text', analyzer: 'english_programmer'
        indexes :br, type: 'text', analyzer: 'brazilian_programmer'
        indexes :es, type: 'text', analyzer: 'spanish_programmer'
      end

      indexes :tags_text do
        indexes :en, type: 'text', analyzer: 'english_programmer'
        indexes :br, type: 'text', analyzer: 'brazilian_programmer'
        indexes :es, type: 'text', analyzer: 'spanish_programmer'
      end

      indexes :instructors_text do
        indexes :en, type: 'text', analyzer: 'english_programmer'
        indexes :br, type: 'text', analyzer: 'brazilian_programmer'
        indexes :es, type: 'text', analyzer: 'spanish_programmer'
      end

      indexes :provider_name_text do
        indexes :en, type: 'text', analyzer: 'english_programmer'
        indexes :br, type: 'text', analyzer: 'brazilian_programmer'
        indexes :es, type: 'text', analyzer: 'spanish_programmer'
      end

      indexes :pace, type: 'keyword'
      indexes :price, type: 'double'
      indexes :effort, type: 'integer'
      indexes :free_content, type: 'boolean'
      indexes :paid_content, type: 'boolean'
      indexes :subscription_type, type: 'boolean'
      indexes :has_free_trial, type: 'boolean'
      indexes :audio, type: 'keyword'
      indexes :root_audio, type: 'keyword'
      indexes :subtitles, type: 'keyword'
      indexes :root_subtitles, type: 'keyword'
      indexes :offered_by, type: 'object'
      indexes :instructors, type: 'object'
      indexes :category, type: 'keyword'
      indexes :certificate, type: 'object'
      indexes :level, type: 'keyword'
      indexes :slug, type: 'keyword'
      indexes :tags, type: 'keyword'
      indexes :curated_tags, type: 'keyword'
      indexes :curated_root_tags, type: 'keyword'
      indexes :provider_name, type: 'keyword'
      indexes :provider_slug, type: 'keyword'
      indexes :trial_period, type: 'object'
      indexes :subscription_period, type: 'object'
      indexes :video, type: 'object'
    end
  end

  scope :by_category, ->(category) { where(category: category) }
  scope :by_provider,
        ->(provider) { joins(:provider).where('providers.slug = ?', provider) }
  scope :free, -> { where(free_content: true) }
  scope :featured, -> { order('enrollments_count DESC') }
  scope :locales, ->(l) { where('audio && ARRAY[?]::text[]', l) }
  scope :by_provider_tags, ->(tags) { where('tags @> ARRAY[?]::text[]', tags) }
  scope :with_tags,
        -> { where("curated_tags IS NOT NULL AND curated_tags <> '{}'") }
  scope :by_tags,
        ->(tags) { where('curated_tags @> ARRAY[?]::varchar[]', tags) }
  scope :published, -> { where(published: true) }

  def self.unnest_curated_tags(sub_query = 'courses')
    select('*').from(
      select('unnest(curated_tags) as tag').from(sub_query),
      :unnested_curated_tags
    )
  end

  def self.unnest_array_type(field)
    select('distinct *').from(
      select("unnest(#{field}) as tag").from('courses'),
      :"unnested_#{field}"
    )
  end

  def self.count_by_bundle(tag)
    query = <<-SQL
      select tag, count(*) FROM (
        select unnest(curated_tags) as tag FROM (
          select * from courses where ? = ANY(curated_tags)
        ) t
      ) tags GROUP by tag
    SQL
    connection.select_all(sanitize_sql_array([query, tag]))
  end

  def self.distinct_tags
    unnest_array_type('tags').map { |r| r['tag'] }.compact
  end

  def self.distinct_curated_tags
    unnest_array_type('curated_tags').map { |r| r['tag'] }
  end

  def similar
    result = []

    if self.audio && self.audio.length > 0
      result +=
        self.class.published.by_tags(self.curated_tags).locales(self.audio.uniq)
          .order('enrollments_count DESC')
          .limit(SIMILAR_COURSES)
          .to_a
    end

    if result.size < SIMILAR_COURSES
      result +=
        self.class.published.where.not(id: result.map(&:id)).by_tags(
          self.curated_tags
        )
          .order('enrollments_count DESC')
          .limit(SIMILAR_COURSES - result.size)
          .to_a
    end

    result
  end

  def root_languages_for_audio
    audio.map { |lang| lang.split('-')[0] }.uniq
  rescue StandardError
    []
  end

  def root_languages_for_subtitles
    subtitles.map { |lang| lang.split('-')[0] }.uniq
  rescue StandardError
    []
  end

  def video_thumbnail
    return nil unless video['thumbnail_url']
    crypto = Thumbor::CryptoURL.new ENV.fetch('THUMBOR_SECURITY_KEY')
    path =
      crypto.generate(width: 240, image: CGI.escape(video['thumbnail_url']))
    ENV.fetch('THUMBOR_HOST').chomp('/') + path
  end

  def subscription_type?
    main_pricing_model.try(:[], 'type') == 'subscription'
  end

  def has_free_trial?
    !main_pricing_model.try(:[], 'trial_period')&.empty?
  end

  def price
    (main_pricing_model.try(:[], 'price') || self[:price]).to_f
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
    (provider.afn_url_template&.chomp('/') || url) %
      {
        click_id: click_id,
        course_url:
          provider.encoded_deep_linking? ? ERB::Util.url_encode(url) : url
      }
  end

  def gateway_path
    Rails.application.routes.url_helpers.gateway_path(id)
  end

  def instructors
    (self[:instructors] || []).map do |instructor|
      profile =
        OrphanedProfile.enabled.with_slug.where(name: instructor['name']).first
      if profile
        instructor['profile_path'] =
          Rails.application.routes.url_helpers.orphaned_profile_path(
            profile.slug
          )
      end

      instructor
    end
  end

  def details_path
    if slug.present? && provider.slug.present?
      Rails.application.routes.url_helpers.course_path(provider.slug, slug)
    else
      nil
    end
  end

  def as_indexed_json(options = {})
    indexed_json = {
      id: id,
      name: name,
      description: description,
      slug: slug,
      url: url,
      pace: pace,
      effort: effort,
      gateway_path: gateway_path,
      offered_by: offered_by || [],
      instructors: instructors,
      free_content: free_content?,
      paid_content: paid_content?,
      subscription_type: subscription_type?,
      trial_period: trial_period,
      subscription_period: subscription_period,
      has_free_trial: has_free_trial?,
      url_id: url_md5,
      level: level,
      video_url: nil,
      details_path: details_path,
      video: (video && video.merge(thumbnail_url: video_thumbnail)),
      tags: tags,
      audio: audio,
      root_audio: root_languages_for_audio,
      subtitles: subtitles,
      root_subtitles: root_languages_for_subtitles,
      category: category,
      provider_name: provider_name,
      curated_tags: curated_tags,
      curated_root_tags: (curated_tags & RootTag.all.map(&:id)),
      provider_slug: provider_slug,
      syllabus_markdown: syllabus,
      refinement_tags: refinement_tags,
      type: self.class.name
    }

    indexed_json[:provider_name_text] = SITE_LOCALES.map do |key, locale|
      [ key, provider_name ]
    end.to_h

    if instructors.present?
      indexed_json[:instructors_text] = SITE_LOCALES.map do |key, locale|
        [
          key,
          instructors.map{ |i| i['name'] }.compact
        ]
      end.to_h
    end

    if category.present?
      indexed_json[:category_text] =
        SITE_LOCALES.map do |key, locale|
          [key, I18n.t("tags.#{category}", locale: locale)]
        end.to_h
    end

    if tags.present?
      indexed_json[:tags_text] =
        SITE_LOCALES.map do |key, locale|
          [
            key,
            tags.map do |tag|
              I18n.t("tags.#{tag}", locale: locale, default: tag)
            end
          ]
        end.to_h
    end

    if free_content?
      indexed_json[:price] = 0
    else
      indexed_json[:price] = price
    end

    if certificate.present?
      indexed_json[:certificate] = {
        type: certificate[:type],
        price: certificate[:price],
        currency: certificate[:currency]
      }
    end

    indexed_json
  end

  class << self
    def bulk_upsert(values)
      result =
        import values,
               validate: false,
               on_duplicate_key_update: {
                 conflict_target: %i[global_id],
                 columns: %i[duration_in_hours name]
               }
      bulk_index_async(result.ids)
    end

    def current_dataset_sequence
      maximum(:dataset_sequence) || 0
    end

    def reset_index!
      begin
        __elasticsearch__.delete_index!
      rescue StandardError
        nil
      end
      __elasticsearch__.create_index!
    end

    def reindex!
      reset_index!
      default_import_to_search_index
    end

    def index_by_dataset_sequence(sequence)
      __elasticsearch__.import query: -> do
        where(published: true, source: 'api')
        .where('dataset_sequence >= ?', sequence)
        .includes(:provider)
      end
    end

    def remove_from_index_by_dataset_sequence(sequence)
      self.select(:id)
      .where(published: false)
      .where('dataset_sequence >= ?', sequence)
      .find_in_batches(batch_size: 100) do |courses|
        body = courses.map do |course|
          {
            delete: {
              _index: __elasticsearch__.index_name,
              _type:  __elasticsearch__.document_type,
              _id:    course.id
            }
          }
        end
        __elasticsearch__.client.bulk body: body
      end
    end

    def default_import_to_search_index
      import_to_search_index({ published: true, source: 'api' })
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
