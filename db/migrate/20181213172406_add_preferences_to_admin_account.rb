class AddPreferencesToAdminAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_accounts, :preferences, :jsonb, default: {}
  end
end
