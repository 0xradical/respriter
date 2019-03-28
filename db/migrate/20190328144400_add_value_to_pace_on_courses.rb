class AddValueToPaceOnCourses < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!
  def change
    execute "ALTER TYPE pace ADD VALUE 'live_class'"
  end
end
