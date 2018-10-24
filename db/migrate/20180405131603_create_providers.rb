class CreateProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :providers do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.string  :afn_url_template
      t.boolean :published
      t.datetime :published_at
      t.timestamps
    end
  end
end
