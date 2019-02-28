class AlterLevelOnCourses < ActiveRecord::Migration[5.2]
  def change
    remove_column :courses, :level
    add_column :courses, :level, :level, array: true, default: []
  end
end
