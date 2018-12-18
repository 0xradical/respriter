class AddSourceToCourses < ActiveRecord::Migration[5.2]
  def change

    execute <<-SQL
      CREATE TYPE source AS ENUM ('api', 'import', 'admin');
    SQL

    add_column :courses, :source, :string
    Course.update_all("source = 'api'")

  end
end
