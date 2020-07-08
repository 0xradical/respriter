class Enrollment < ApplicationRecord

  has_many   :tracked_actions
  belongs_to :user_account, optional: true
  belongs_to :course, optional: true, counter_cache: true
  belongs_to :provider, optional: true
end
