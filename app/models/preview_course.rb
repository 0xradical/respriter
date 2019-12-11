class PreviewCourse < ApplicationRecord
  has_one :desktop_course_page_screenshot, as: :imageable, class_name: 'PreviewCourseImage', dependent: :destroy
  has_one :mobile_course_page_screenshot, as: :imageable, class_name: 'PreviewCourseImage', dependent: :destroy

  def add_screenshot!(type, attributes)
    blob_params  = attributes.extract!(:file)
    send("create_#{type}", attributes).tap do |image|
      image.file = blob_params[:file]
    end.save!
    send(type)
  end
end