class Profile < ApplicationRecord

  include Imageable::HasOne
  initialize_imageable_module :image

  belongs_to :user_account

  def avatar(version=:sm)
    image_url(version) || user_account.oauth_accounts.map(&:avatar).first
  end

end
