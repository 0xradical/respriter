CREATE FUNCTION triggers.preview_course_flatten_pricing_models() RETURNS trigger AS $$
DECLARE
  price jsonb;
BEGIN
  IF (NEW.__source_schema__::jsonb)->'content'->>'prices' IS NOT NULL THEN
    FOR price IN SELECT * FROM jsonb_array_elements((NEW.__source_schema__->'content'->>'prices')::jsonb)
    LOOP
      SELECT app.insert_into_preview_course_pricings(NEW.id, price);
    END LOOP;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;