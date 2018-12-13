class CreateLandingPages < ActiveRecord::Migration[5.2]
  def change
    create_table :landing_pages do |t|
      t.string :slug
      t.string :template
      t.text  :meta_html
      t.jsonb :html, default: {}
      t.text  :body_html
      t.timestamps
    end
  end
end
