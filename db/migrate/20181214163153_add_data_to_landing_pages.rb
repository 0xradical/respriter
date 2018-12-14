class AddDataToLandingPages < ActiveRecord::Migration[5.2]
  def change
    add_column :landing_pages, :data, :jsonb, default: {}
  end
end
