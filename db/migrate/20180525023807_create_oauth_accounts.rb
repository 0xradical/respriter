class CreateOauthAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :oauth_accounts do |t|
      t.string :provider
      t.string :uid
      t.jsonb :raw_data, default: {}, null: false
      t.references :user_account, foreign_key: true
      t.timestamps null: false
    end
  end
end
