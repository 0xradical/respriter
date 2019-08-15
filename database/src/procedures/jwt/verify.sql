CREATE FUNCTION jwt.verify(
  token     text,
  secret    text,
  algorithm text DEFAULT 'HS256'
) RETURNS table(header json, payload json, valid boolean)
AS $$
  SELECT
    convert_from(jwt.url_decode(r[1]), 'utf8')::json AS header,
    convert_from(jwt.url_decode(r[2]), 'utf8')::json AS payload,
    r[3] = jwt.algorithm_sign(r[1] || '.' || r[2], secret, algorithm) AS valid
  FROM regexp_split_to_array(token, '\.') r;
$$ LANGUAGE sql;
