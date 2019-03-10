class RollbackInsertOrAddProviderStoredProcedure < ActiveRecord::Migration[5.2]
  def change
    execute <<-SQL
      DROP TRIGGER before_insert ON courses;
    SQL
  end
end
