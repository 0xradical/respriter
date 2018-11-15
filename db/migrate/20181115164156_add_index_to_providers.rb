class AddIndexToProviders < ActiveRecord::Migration[5.2]
  def change
    add_index :providers, :slug, unique: true
    add_index :providers, :name, unique: true
  end
end
