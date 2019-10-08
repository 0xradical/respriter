class UserAccount < ApplicationRecord

  devise :database_authenticatable, :confirmable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :omniauthable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null, omniauth_providers: [:facebook, :github, :linkedin]

  attr_accessor :skip_password_validation

  has_many :oauth_accounts, dependent: :destroy
  has_one  :profile,        dependent: :destroy

  has_many :enrollments,       dependent: :nullify
  has_many :enrolled_courses,  through: :enrollments,   source: :course

  #has_many :favorites,         dependent: :destroy
  #has_many :favorite_courses,  through: :favorites,     source: :course

  delegate :avatar_url, to: :profile

  validates :email, 'valid_email_2/email': { mx: true, disposable: true, disallow_subaddressing: true}

  def add_oauth_account(oauth)
    oauth_accounts.find_or_create_by(provider: oauth[:provider], uid: oauth[:uid]) do |oauth_acc|
      oauth_acc.raw_data = oauth
    end
  end

  def jwt_payload
    { role: 'user' }
  end

  def password_required?
    return false if skip_password_validation
    super
  end

  def soft_delete
    transaction do
      update_columns({
        destroyed_at: Time.current,
        email: "#{email}###+destroyed+#{SecureRandom.hex(6)}###"
      })
      oauth_accounts.update_all("uid = concat(uid, '+destroyed+', id)")
    end
  end

  # ensure user account is active
  # def active_for_authentication?
    # super && !destroyed_at
  # end

  # provide a custom message for a deleted account
  #def inactive_message
 #   !destroyed_at ? super : :deleted_account
 # end

end
