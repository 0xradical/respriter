class AdminProfile < ApplicationRecord

  include Imageable::HasOne
  initialize_imageable_module :avatar

  belongs_to :admin_account

end
