class AddActionToTrackedSearch < ActiveRecord::Migration[5.2]
  def change
    add_column :tracked_searches, :action, :string
    add_index  :tracked_searches, :action

    TrackedSearch.update_all action: :course_search
  end
end
