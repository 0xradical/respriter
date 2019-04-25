class AddProductNameToTrackedActions < ActiveRecord::Migration[5.2]
  def change
    add_column :tracked_actions, :ext_product_name, :string
    TrackedAction.update_all('ext_product_name = ext_sku_name')

    # remove earnings view first
    reversible do |dir|
      dir.up do
        execute 'DROP VIEW earnings;'
      end
      dir.down do
        execute(File.read(Rails.root.join('db/views/earnings_v01.sql')))
      end
    end

    remove_column :tracked_actions, :ext_sku_name

    # recreate earnings view with newly created column
    reversible do |dir|
      dir.up do
        execute(File.read(Rails.root.join('db/views/earnings_v02.sql')))
      end
      dir.down do
        execute 'DROP VIEW earnings;'
      end
    end
  end
end
