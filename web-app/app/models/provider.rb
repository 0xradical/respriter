# frozen_string_literal: true

class Provider < ApplicationRecord
  include Slugifyable
  include IndexableByRobots

  slugify run_on:           :before_save,
          callback_options: { if: -> { slug.blank? && name.present? } }

  scope :slugged, -> { where.not(slug: nil) }
  scope :published, -> { where(published: true) }
  scope :featured_on_footer, -> { where(featured_on_footer: true) }

  has_one  :provider_price_range
  has_many :courses, dependent: :destroy
  has_many :enrollments
  has_many :post_relations, as: :relation
  has_many :posts, through: :post_relations

  # weak relationships
  def instructors
    OrphanedProfile.enabled.where("teaching_at @> ('{' || ? || '}')::varchar[]", name)
  end

  # api
  def forwarding_url(url, click_id:)
    url ||= self.url

    format(
      (afn_url_template&.chomp('/') || url),
      click_id: click_id,
      url:      encoded_deep_linking? ? ERB::Util.url_encode(url) : url
    )
  end

  # queries
  def areas_of_knowledge
    self.class.select('count(*) as count_all, tag').from(
      courses.published.select('unnest(curated_tags) as tag'),
      :unnested_curated_tags
    ).where('tag in (?)', RootTag.all.map(&:id)).group('tag').order([count_all: :desc]).limit(1).map(&:tag)
  end

  def recommended_courses(locale = I18n.locale, count = 12)
    locales = [locale.to_s.gsub(/-.*/, '').presence, locale].compact.map { |l| "'#{l}'" }
    courses.published.order("(audio && ARRAY[#{locales.join(',')}]::text[])::int DESC NULLS LAST").order('enrollments_count DESC, video NULLS LAST').limit(count)
  end

  def top_countries(n = 5)
    enrollments.select("count(*) as count_all, tracking_data->>'country' as country").where("tracking_data->>'country' is not null").group('country').order(count_all: :desc).limit(n).map(&:country)
  end

  def membership_types
    courses.published.select("distinct jsonb_array_elements(pricing_models)->>'type' as membership_type").map(&:membership_type)
  end

  def price_range
    [provider_price_range.min, provider_price_range.max]
  rescue StandardError
    []
  end

  def has_trial?
    self.class.select('trial_value').from(
      courses.published.select("jsonb_array_elements(pricing_models)->'trial_period'->>'value' as trial_value"),
      :unnested_pricing_models
    ).where('trial_value is not null').count > 0
  end
end
