# frozen_string_literal: true

class PreviewCourse < Course
  self.table_name = 'preview_courses'

  has_many :preview_course_images, dependent: :destroy
  has_many :pricings, class_name: 'PreviewCoursePricing', foreign_key: 'preview_course_id'

  def add_screenshot!(type, file)
    screenshot = preview_course_images.where(kind: type).first_or_initialize
    screenshot.file = file
    screenshot.save!

    screenshot
  end

  def gateway_path
    url
  end

  def details_path
    url
  end

  def dataset_sequence=(*); end

  def global_sequence=(*); end

  def resource_sequence=(*); end

  def last_execution_id=(*); end

  def schema_version=(*); end
end
