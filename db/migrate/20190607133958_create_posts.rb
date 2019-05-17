class CreatePosts < ActiveRecord::Migration[5.2]
  def change

    execute "CREATE TYPE post_status AS ENUM ('void','draft','published')"

    create_table :posts do |t|
      t.string :slug
      t.string :title
      t.text :body
      t.string :tags, array: true, default: []
      t.jsonb :meta, default: {}
      t.column  :locale, :iso639_code, default: 'en'
      t.column  :status, :post_status, default: 'draft'
      t.string :content_fingerprint
      t.datetime :published_at
      t.datetime :content_changed_at
      t.references :admin_account
      t.timestamps
    end

    add_index :posts, :tags, using: :gin
    add_index :posts, :slug, unique: true, using: :btree

  end
end
