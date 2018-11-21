class Enrollment < ApplicationRecord

  belongs_to :user_account, optional: true
  belongs_to :course

end
