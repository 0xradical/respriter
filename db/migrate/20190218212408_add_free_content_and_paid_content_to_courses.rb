class AddFreeContentAndPaidContentToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :free_content, :boolean, default: false
    add_column :courses, :paid_content, :boolean, default: true
    execute <<-SQL
      UPDATE courses SET free_content = (source_schema -> 'content' ->> 'free_content')::boolean, paid_content = (source_schema -> 'content' ->> 'paid_content')::boolean
    SQL
  end
end
