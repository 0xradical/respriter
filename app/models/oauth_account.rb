class OauthAccount < ApplicationRecord

  belongs_to :user_account

  scope :_provider_, -> (provider) { where(provider: provider) }

  def avatar
    raw_data['info']['image']
  end

  class << self

    def from_provider(oauth:, session: {})

      oauth_account = find_or_create_by(provider: oauth['provider'], uid: oauth['uid']) do |oauth_acc|
        oauth_acc.raw_data = oauth
      end

      return oauth_account.user_account if oauth_account.user_account.present?

      user = UserAccount.find_or_create_by(email: oauth[:info][:email]) do |user|
        user.tracking_data                  = session&.[](:tracking_data) || {}
        user.skip_password_validation       = true
        user.confirmed_at                   = Time.current
        user.skip_confirmation_notification!
      end

      user.profile.avatar ||= oauth['info']['image']
      user.profile.name   ||= oauth['info']['name']
      user.profile.save
      user.oauth_accounts << oauth_account

      return user

      rescue ActiveRecord::RecordNotUnique
        retry
    end

  end

end
