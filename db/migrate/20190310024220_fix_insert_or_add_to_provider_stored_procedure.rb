class FixInsertOrAddToProviderStoredProcedure < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :__provider_name__, :string
    remove_column :courses, :__source_schema__

    execute <<-SQL
      CREATE OR REPLACE FUNCTION _insert_or_add_to_provider() RETURNS TRIGGER AS $$
      DECLARE
        _provider providers%ROWTYPE;
        _new_provider_id int;
      BEGIN
        SELECT * FROM providers INTO STRICT _provider where name = 'NEW.__provider_name__';
        IF (_provider IS NULL) THEN
          INSERT INTO providers (name, published, created_at, updated_at) VALUES (NEW.__provider_name__, false, NOW(), NOW()) RETURNING id INTO _new_provider_id;
          NEW.published = false;
          NEW.provider_id = _new_provider_id;
        ELSE
          NEW.provider_id = _provider.id;
        END IF;
        RETURN NEW;
      END;
      $$ language plpgsql
    SQL

  end
end
