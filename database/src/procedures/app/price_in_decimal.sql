CREATE OR REPLACE FUNCTION app.price_in_decimal(price text)
  RETURNS DECIMAL AS
$$
BEGIN
   IF $1 = '' THEN  -- special case for empty string like requested
      RETURN 0::DECIMAL(12,2);
   ELSE
      RETURN $1::DECIMAL(12,2);
   END IF;

EXCEPTION WHEN OTHERS THEN
   RETURN NULL;  -- NULL for other invalid input

END
$$ LANGUAGE plpgsql IMMUTABLE;