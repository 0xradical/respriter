class AddValueToCategoryEnum < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!
  def change
    execute "ALTER TYPE category ADD VALUE 'social_sciences';"
    execute "UPDATE courses SET category = 'social_sciences' WHERE category = 'social_science'"
  end
end
