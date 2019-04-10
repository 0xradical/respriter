class AddInstructorsOnCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :instructors, :jsonb, default: []
  end
end
