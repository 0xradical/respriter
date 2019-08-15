CREATE FUNCTION triggers.sort_prices() RETURNS trigger AS $$
DECLARE
  price                 jsonb;
  prices                jsonb[];
  results               jsonb[];
  single_course_prices  jsonb[];
  subscription_prices   jsonb[];
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
  NEW.__source_schema__ = NULL;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
