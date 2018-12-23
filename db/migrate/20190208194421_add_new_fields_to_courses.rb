class AddNewFieldsToCourses < ActiveRecord::Migration[5.2]
  def change

    execute <<-SQL
      CREATE TYPE pace AS ENUM ('self_paced','instructor_paced');
      CREATE TYPE level AS ENUM ('beginner','intermediate','advanced');
    SQL

    add_column :courses, :pace, :pace
    add_column :courses, :level, :level
    add_column :courses, :certificate, :jsonb, default: '{}' 
    add_column :courses, :pricing_models, :jsonb, default: '[]'
    add_column :courses, :offered_by, :jsonb, default: '[]'
    add_column :courses, :syllabus, :text
    add_column :courses, :effort, :integer
    remove_column :courses, :payload
    add_column :courses, :source_schema, :jsonb

    Course.reset_column_information
    Course.update_all("pricing_models = '[]', offered_by = '[]', certificate = '{}'")

    execute <<-SQL
      CREATE OR REPLACE FUNCTION sort_prices() RETURNS TRIGGER AS $$
      DECLARE
      price jsonb;
      prices jsonb[];
      results jsonb[];
      single_course_prices jsonb[];
      subscription_prices jsonb[];
      BEGIN
        FOR price IN SELECT * FROM jsonb_array_elements((NEW.source_schema -> 'content' ->> 'prices')::jsonb)
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
