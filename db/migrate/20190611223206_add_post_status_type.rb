class AddPostStatusType < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!
  def change
    execute "ALTER TYPE post_status ADD value 'disabled'"
  end
end
