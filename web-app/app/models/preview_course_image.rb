class PreviewCourseImage < ApplicationRecord
  mount_uploader :file, PreviewCourseImageUploader
  belongs_to :preview_course
end
