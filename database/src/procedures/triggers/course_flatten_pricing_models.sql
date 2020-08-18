CREATE FUNCTION triggers.course_flatten_pricing_models() RETURNS trigger AS $$
DECLARE
  price jsonb;
BEGIN
  IF (NEW.__source_schema__::jsonb)->'content'->>'prices' IS NOT NULL THEN
    FOR price IN SELECT * FROM jsonb_array_elements((NEW.__source_schema__->'content'->>'prices')::jsonb)
    LOOP
      PERFORM app.insert_into_course_pricings(NEW.id, price);
    END LOOP;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;