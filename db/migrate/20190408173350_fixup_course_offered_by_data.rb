class FixupCourseOfferedByData < ActiveRecord::Migration[5.2]
  def up
    execute %Q{
      UPDATE courses SET offered_by = '[]'::jsonb WHERE offered_by IS NULL
    }
  end

  def down; end
end
