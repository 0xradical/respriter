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
      oauth_account.user_account  = UserAccount.find_or_create_by(email: oauth[:info][:email]) do |account|
        account.password                  = Devise.friendly_token[0,20]
        account.tracking_data             = session[:tracking_data]
        account.confirmed_at              = Time.now
      end
      oauth_account.user_account.reload.profile.oauth_avatar_url = oauth[:info][:image]
      oauth_account.save!
      oauth_account
    end

  end

end
