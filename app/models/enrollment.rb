class Enrollment < ApplicationRecord

  has_many   :tracked_actions
  belongs_to :user_account, optional: true
  belongs_to :course

end
