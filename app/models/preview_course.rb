class PreviewCourse < ApplicationRecord
  belongs_to :provider_crawler
  has_one :provider, through: :provider_crawler
  has_many :screenshots, as: :imageable, class_name: 'PreviewCourseImage', dependent: :destroy

  def add_screenshot!(type, file)
    screenshot = screenshots.where(caption: type).first_or_initialize
    screenshot.file = file
    screenshot.save!

    screenshot
  end

  def as_indexed_json
    self[:data].dig('course', 'payload')
  end

  def video
    as_indexed_json['video']
  end
end