class AddCuratedTagsToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :curated_tags, :string, array: true, default: []
  end
end
