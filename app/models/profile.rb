class Profile < ApplicationRecord
  has_many :used_usernames

  include Imageable::HasOne
  initialize_imageable_module :image

  belongs_to :user_account

  def avatar_url
    uploaded_avatar_url || oauth_avatar_url
  end

end
