class OauthAccount < ApplicationRecord

  belongs_to :user_account

  scope :_provider_, -> (provider) { where(provider: provider) }

  def avatar
    raw_data['info']['image']
  end

  class << self

    def user_account_from!(oauth:, session: {})
      oauth_account = where(provider: oauth[:provider], uid: oauth[:uid]).first_or_initialize
      oauth_account.raw_data = oauth

      return oauth_account if oauth_account.user_account.present?

      # Emails are not required for omniauth authentication, however we should still enforce
      # database level constraints for all the cases where a unique non-null email is required.
      oauth_email = oauth[:info][:email].present? ? oauth[:info][:email] : "#{oauth[:provider]}-#{oauth[:uid]}@users.classpert.com"
      oauth_account.user_account  = UserAccount.find_or_create_by!(email: oauth_email) do |account|
        account.autogen_email_for_oauth = oauth[:info][:email].blank?
        account.password                = Devise.friendly_token[0,20]
        account.tracking_data           = session[:tracking_data]
        account.confirmed_at            = Time.now
      end

      oauth_account.save!
      oauth_account
    end

  end

end
