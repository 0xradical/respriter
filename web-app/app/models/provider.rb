# frozen_string_literal: true

class Provider < ApplicationRecord
  include Slugifyable
  include IndexableByRobots

  slugify run_on:           :before_save,
          callback_options: { if: -> { slug.blank? && name.present? } }

  scope :slugged, -> { where.not(slug: nil) }
  scope :published, -> { where(published: true) }

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
    self.class.select("distinct on (category) count(*) as count_all, tag, (case when tag in (#{RootTag.all.map { |t| "'#{t.id}'" }.join(',')}) then 0 else 1 end) as category").from(
      courses.select('unnest(curated_tags) as tag'),
      :unnested_curated_tags
    ).group('tag').order([:category, count_all: :desc]).map(&:tag)
  end

  def top_countries(n = 5)
    enrollments.select("count(*) as count_all, tracking_data->>'country' as country").where("tracking_data->>'country' is not null").group('country').order(count_all: :desc).limit(n).map(&:country)
  end

  def membership_types
    courses.select("distinct jsonb_array_elements(pricing_models)->>'type' as membership_type").map(&:membership_type)
  end

  def price_range
    self.class.select('min(price) as min_price, max(price) as max_price').from(
      courses.select("jsonb_array_elements(pricing_models)->>'price' as price"),
      :unnested_pricing_models
    ).map { |e| [e.min_price, e.max_price] }.first.sort_by { |a, b| a.to_f - b.to_f }
  end

  def has_trial?
    self.class.select('trial_value').from(
      courses.select("jsonb_array_elements(pricing_models)->'trial_period'->>'value' as trial_value"),
      :unnested_pricing_models
    ).where('trial_value is not null').count > 0
  end
end
