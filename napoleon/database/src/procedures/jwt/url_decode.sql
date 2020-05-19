CREATE FUNCTION jwt.url_decode(data text) RETURNS bytea
AS $$
WITH
  t   AS ( SELECT translate(data, '-_', '+/') ),
  rem AS ( SELECT length((SELECT * FROM t)) % 4) -- compute padding size
  SELECT decode(
    (SELECT * FROM t) ||
    CASE WHEN (SELECT * FROM rem) > 0
      THEN repeat('=', (4 - (SELECT * FROM rem)))
      ELSE ''
    END,
    'base64'
  );
$$ IMMUTABLE LANGUAGE sql;
