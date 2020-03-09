class UserAccount < ApplicationRecord
  devise :database_authenticatable,
         :confirmable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :omniauthable,
         :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null,
         omniauth_providers: %i[facebook github linkedin],
         authentication_keys: {email: false, login: false}

  attr_accessor :skip_password_validation, :login

  has_many :oauth_accounts, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :used_usernames, through: :profile
  accepts_nested_attributes_for :profile

  has_many :enrollments, dependent: :nullify
  has_many :enrolled_courses, through: :enrollments, source: :course

  has_many :tracked_actions, through: :enrollments
  has_many :course_reviews
  has_many :certificates, dependent: :destroy

  delegate :avatar_url, to: :profile, allow_nil: true

  validates :email, 'valid_email_2/email': { mx: true, disposable: true, disallow_subaddressing: true}

  def add_oauth_account(oauth)
    oauth_accounts.find_or_create_by(
      provider: oauth[:provider], uid: oauth[:uid]
    ) { |oauth_acc| oauth_acc.raw_data = oauth }
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
      update_columns(
        {
          destroyed_at: Time.current,
          email: "#{email}###+destroyed+#{SecureRandom.hex(6)}###"
        }
      )
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
  def self.find_for_database_authentication(warden_condition)
    conditions = warden_condition.dup
    login = conditions.delete(:login)

    if login
      value = login.strip.downcase

      where(conditions).joins(:used_usernames).where(
        [
          'used_usernames.username = :value OR LOWER(user_accounts.email) = :value',
          { value: value }
        ]
      ).first || where(conditions).where([
        'LOWER(user_accounts.email) = :value', { value: value }
      ]).first
    elsif conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
