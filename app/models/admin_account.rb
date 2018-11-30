class AdminAccount < ApplicationRecord
  devise :database_authenticatable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  def jwt_payload
    { preferences: preferences }
  end

end
