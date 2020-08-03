class CourseCategory < ApplicationRecord
  belongs_to :parent, class_name: 'CourseCategory', optional: true
  has_many :children, class_name: 'CourseCategory', foreign_key: :parent_id

  scope :roots, -> { where(parent_id: nil) }
end
