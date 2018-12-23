class RemoveVideoUrlFromCourses < ActiveRecord::Migration[5.2]
  def change
    remove_column :courses, :video_url
    add_column :courses, :payload, :jsonb, default: {}
  end
end
