class CreateAdminProfile < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_profiles do |t|
      t.string :name
      t.text :bio
      t.jsonb :preferences
      t.references :admin_account
      t.timestamps
    end
  end
end
