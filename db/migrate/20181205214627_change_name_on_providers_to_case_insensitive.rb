class ChangeNameOnProvidersToCaseInsensitive < ActiveRecord::Migration[5.2]
  def change
    enable_extension("citext")
    change_column :providers, :name, :citext
    remove_index :providers, :name
    add_index :providers, :name, unique: true
  end
end
