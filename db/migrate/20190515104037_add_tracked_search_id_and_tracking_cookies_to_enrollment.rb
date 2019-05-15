class AddTrackedSearchIdAndTrackingCookiesToEnrollment < ActiveRecord::Migration[5.2]
  def change
    add_column :enrollments, :tracked_search_id, :uuid
    add_column :enrollments, :tracking_cookies,  :jsonb

    add_index :enrollments, :tracked_search_id
  end
end
