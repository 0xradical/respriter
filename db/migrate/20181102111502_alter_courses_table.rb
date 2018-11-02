class AlterCoursesTable < ActiveRecord::Migration[5.2]
  def change
    change_column :courses, :global_sequence, 'integer USING CAST(global_sequence AS integer)'
    add_column    :courses, :dataset_sequence, :integer
    add_column    :courses, :resource_sequence, :integer
    add_column    :courses, :tags, :text, array: true, default: []

    add_index     :courses, :tags, using: 'gin'
    add_index     :courses, :global_sequence
    add_index     :courses, :dataset_sequence
  end
end
