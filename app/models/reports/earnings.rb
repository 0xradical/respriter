class Earnings < ApplicationRecord

  self.primary_key  = 'id'
  default_scope -> { order(ext_click_date: 'ASC') } 

end
