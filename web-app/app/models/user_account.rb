class UserAccount < ApplicationRecord
  DOMAIN_VERIFICATION_KEY = 'classpert-site-verification'

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
         omniauth_providers: %i[facebook reddit github linkedin twitter],
         authentication_keys: {email: false, login: false}

  attr_accessor :skip_password_validation, :login

  has_many :oauth_accounts, dependent: :destroy

  has_one :profile, dependent: :destroy
  has_one :orphaned_profile

  has_many :used_usernames, through: :profile
  accepts_nested_attributes_for :profile

  has_many :enrollments, dependent: :nullify
  has_many :enrolled_courses, through: :enrollments, source: :course

  has_many :tracked_actions, through: :enrollments
  has_many :course_reviews
  has_many :certificates, dependent: :destroy

  delegate :name,
    :avatar_url,
    :short_bio,
    :interests,
    :public_profiles,
    :long_bio,
    :username,
    :interests,
    :instructor,
    to: :profile, allow_nil: true, prefix: false

  validates :email, 'valid_email_2/email': { mx: true, disposable: true, disallow_subaddressing: true}

  scope :is_public,         -> { joins(:profile).where('profiles.public = ?', true) }
  scope :publicly_listable, -> { is_public.where('profiles.username IS NOT NULL AND profiles.name IS NOT NULL') }

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

  def domain_verification_txt_entry
    "#{DOMAIN_VERIFICATION_KEY}=#{self.domain_verification_token}"
  end

  def domain_verification_cname_entry(domain)
    "#{self.domain_verification_token}.#{
      PublicSuffix.parse(domain).domain
    }"
  rescue StandardError
    nil
  end

  def domain_verification_token
    if self.id.present? && ENV['DOMAIN_VERIFICATION_SALT'].present?
      Digest::MD5.hexdigest("#{self.id}#{ENV['DOMAIN_VERIFICATION_SALT']}")
    else
      nil
    end
  end

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
