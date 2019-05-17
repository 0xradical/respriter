class AddCuratedTagsToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :curated_tags, :string, array: true, default: []
    add_index :courses, :curated_tags, using: :gin
  end
end
