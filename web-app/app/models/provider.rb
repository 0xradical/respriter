# frozen_string_literal: true

class Provider < ApplicationRecord
  include Slugifyable
  include IndexableByRobots

  slugify run_on:           :before_save,
          callback_options: { if: -> { slug.blank? && name.present? } }

  scope :slugged, -> { where.not(slug: nil) }
  scope :published, -> { where(published: true) }
  scope :featured_on_footer, -> { where(featured_on_footer: true) }

  has_one  :provider_pricing
  has_one  :provider_stats
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

  def recommended_courses(locale = I18n.locale, count = 12)
    locales = [locale.to_s.gsub(/-.*/, '').presence, locale].compact.uniq.map { |l| "'#{l}'" }
    courses.published.order(Arel.sql("(audio && ARRAY[#{locales.join(',')}]::text[])::int DESC NULLS LAST")).order('enrollments_count DESC, video NULLS LAST').limit(count)
  end
end
