class AddRefinementsOnCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :refinement_tags, :string, array: true
  end
end
