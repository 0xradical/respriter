class Provider < ApplicationRecord

  include Slugifyable
  slugify run_on: :before_save, callback_options: { unless: -> { slug.present? } }

  scope :slugged, -> { where.not(slug: nil) }

  has_many :courses, dependent: :destroy

end
