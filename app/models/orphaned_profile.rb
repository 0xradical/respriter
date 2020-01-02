class OrphanedProfile < ApplicationRecord

  belongs_to :user_account, optional: true

  def claimed?
    !!user_account_id
  end

end
