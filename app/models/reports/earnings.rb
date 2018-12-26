class Earnings < ApplicationRecord

  self.primary_key  = 'id'
  default_scope -> { order(created_at: 'ASC') } 

end
