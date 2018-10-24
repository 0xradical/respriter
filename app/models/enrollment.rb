class Enrollment < ApplicationRecord

  belongs_to :user_account
  belongs_to :course

end
