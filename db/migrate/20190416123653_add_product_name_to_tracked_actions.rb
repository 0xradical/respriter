class AddProductNameToTrackedActions < ActiveRecord::Migration[5.2]
  def change
    add_column :tracked_actions, :ext_product_name, :string
    TrackedAction.update_all('ext_product_name = ext_sku_name')
    remove_column :tracked_actions, :ext_sku_name
  end
end
