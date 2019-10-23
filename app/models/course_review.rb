class CourseReview < ApplicationRecord
  belongs_to :user_account
  belongs_to :tracked_action

  PENDING = 'pending'
  ACCESSED = 'accessed'
  SUBMITTED = 'submitted'

  def course_name
    self.tracked_action.ext_product_name
  end

  def provider
    self.tracked_action.provider
  end

  def submitted?
    self.state == SUBMITTED
  end
end