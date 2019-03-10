class AddSourceSchemaToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :__source_schema__, :jsonb
  end
end
