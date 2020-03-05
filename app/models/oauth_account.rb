class OauthAccount < ApplicationRecord

  belongs_to :user_account

  scope :_provider_, -> (provider) { where(provider: provider) }

  def avatar
    raw_data['info']['image']
  end

  class << self

    def user_account_from!(oauth:, session: {})

      oauth_acc = find_by(provider: oauth['provider'], uid: oauth['uid'])

      if oauth_acc.nil?
        transaction do
          oauth_acc = create(provider: oauth['provider'], uid: oauth['uid'])
          oauth_acc.raw_data = oauth
          oauth_acc.user_account = UserAccount.find_or_create_by(email: oauth[:info][:email]) do |u|
            u.password        = Devise.friendly_token[0,20]
            u.tracking_data   = session[:tracking_data]
            u.confirmed_at    = Time.current
          end
          oauth_acc.save
          oauth_acc.user_account.skip_confirmation_notification!
          oauth_acc.user_account.reload
        end
      end

      oauth_acc.user_account

    end

  end

end
