class Provider < ApplicationRecord

  include Slugifyable
  slugify run_on: :before_save, callback_options: { unless: -> { slug.present? } }

  has_many :courses, dependent: :destroy


end
