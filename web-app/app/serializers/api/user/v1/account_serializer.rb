class Api::User::V1::AccountSerializer
  include FastJsonapi::ObjectSerializer

  attributes :email, :confirmed_at, :last_sign_in_at

  attribute :password_missing do |object|
    object.encrypted_password.blank?
  end

  has_one  :profile
  has_many :oauth_accounts, attributes: [:provider]

end
