class CreateProvidersSp < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!
  def change

    # Vacuum Toast
    execute "ALTER TABLE courses DROP COLUMN source_schema"
    execute "vacuum full"

    add_column :courses, :__source_schema__, :jsonb

    execute <<-SQL
      CREATE OR REPLACE FUNCTION _insert_or_add_to_provider() RETURNS TRIGGER AS $$
      DECLARE
        _provider providers%ROWTYPE;
        _provider_name providers.name%TYPE;
        _new_provider_id int;
      BEGIN
        _provider_name := NEW.__source_schema__ -> 'content' ->> 'provider_name';
        SELECT * FROM providers INTO _provider where providers.name = _provider_name;
        IF (NOT FOUND) THEN
          INSERT INTO providers (name, published, created_at, updated_at) VALUES (_provider_name, false, NOW(), NOW()) RETURNING id INTO _new_provider_id;
          NEW.published = false;
          NEW.provider_id = _new_provider_id;
        ELSE
          NEW.provider_id = _provider.id;
        END IF;
        NEW.__source_schema__ = NULL;
        RETURN NEW;
      END;
      $$ language plpgsql
    SQL

    execute <<-SQL
      CREATE TRIGGER before_insert
      BEFORE INSERT OR UPDATE ON public.courses
      FOR EACH ROW
      EXECUTE PROCEDURE _insert_or_add_to_provider()
    SQL

    # Fix prices SP
    execute <<-SQL
      DROP TRIGGER sort_prices ON courses;
      CREATE OR REPLACE FUNCTION sort_prices() RETURNS TRIGGER AS $$
      DECLARE
      price jsonb;
      prices jsonb[];
      results jsonb[];
      single_course_prices jsonb[];
      subscription_prices jsonb[];
      BEGIN
        FOR price IN SELECT * FROM jsonb_array_elements((NEW.__source_schema__ -> 'content' ->> 'prices')::jsonb)
        LOOP
          IF (price ->> 'type' = 'single_course') THEN
            single_course_prices := array_append(single_course_prices,price);
          ELSIF (price ->> 'type' = 'subscription') THEN
            IF (price -> 'subscription_period' ->> 'unit' = 'months') THEN
              subscription_prices := array_prepend(price,subscription_prices);
            ELSIF (price -> 'subscription_period' ->> 'unit' = 'years') THEN
              subscription_prices := array_append(subscription_prices,price);
            END IF;
          END IF;
        END LOOP;
        results := (single_course_prices || subscription_prices);
        IF array_length(results,1) > 0 THEN
          NEW.pricing_models = to_jsonb(results);
        END IF;
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER sort_prices
      BEFORE INSERT OR UPDATE ON public.courses
      FOR EACH ROW
      EXECUTE PROCEDURE sort_prices()
    SQL
    

  end
end
