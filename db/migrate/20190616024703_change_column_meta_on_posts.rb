class ChangeColumnMetaOnPosts < ActiveRecord::Migration[5.2]
  def change
    change_column :posts, :meta, :jsonb, default: '{"title": "", "description": ""}'
  end
end
