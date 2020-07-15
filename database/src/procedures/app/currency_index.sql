CREATE OR REPLACE FUNCTION app.currency_index(currency varchar)
RETURNS BIGINT AS $$
BEGIN
  CASE
  WHEN currency = 'USD' THEN
    RETURN 0;
  WHEN currency = 'EUR' THEN
    RETURN 1;
  WHEN currency = 'GPB' THEN
    RETURN 2;
  WHEN currency = 'BRL' THEN
    RETURN 3;
  ELSE
    RETURN 4;
  END CASE;
END;
$$ LANGUAGE plpgsql STRICT IMMUTABLE;
