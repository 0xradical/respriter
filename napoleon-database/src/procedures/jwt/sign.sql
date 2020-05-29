CREATE FUNCTION jwt.sign(
  payload json,
  secret text,
  algorithm text DEFAULT 'HS256'
) RETURNS text
AS $$
  WITH
    header AS (
      SELECT jwt.url_encode(convert_to('{"alg":"' || algorithm || '","typ":"JWT"}', 'utf8'))
    ),
    payload AS (
      SELECT jwt.url_encode(convert_to(payload::text, 'utf8'))
    ),
    signables AS (
      SELECT (SELECT * FROM header) || '.' || (SELECT * FROM payload)
    )

  SELECT
    (SELECT * FROM signables) ||
    '.' ||
    jwt.algorithm_sign(
      (SELECT * FROM signables),
      secret,
      algorithm
    );
$$ LANGUAGE sql;
