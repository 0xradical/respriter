class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :name
      t.date :date_of_birth
      t.string :avatar
      t.text :interests, array: true, default: []
      t.jsonb :preferences, default: {}
      t.references :user_account, foreign_key: true
    end
    add_index :profiles, :user_account_id, unique: true
  end
end
