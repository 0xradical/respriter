class ChangeLandingPageSlugColumnType < ActiveRecord::Migration[5.2]
  def change
    change_column :landing_pages, :slug, :citext
    add_index :landing_pages, :slug, unique: true
  end
end
