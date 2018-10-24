class CreateImages < ActiveRecord::Migration[5.2]
  def change

    create_table "images", force: :cascade do |t|
      t.string   "caption"
      t.string   "file"
      t.integer  "pos", default: 0
      t.string   "imageable_type"
      t.integer  "imageable_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index :images, [:imageable_type, :imageable_id]

  end
end
