class AdminAccount < ApplicationRecord
  devise :database_authenticatable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  has_one :profile, class_name: 'AdminProfile'

  after_initialize :build_profile

  delegate :name, :bio, :avatar, to: :profile

  has_many :posts do
    def void
      create(status: 'void')
    end
  end

  def jwt_payload
    { preferences: preferences }
  end

  def build_profile
    self.profile = profile || super
  end

end
