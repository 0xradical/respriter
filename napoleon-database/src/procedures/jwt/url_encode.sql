CREATE FUNCTION jwt.url_encode(data bytea) RETURNS text
AS $$
  SELECT translate(encode(data, 'base64'), E'+/=\n', '-_');
$$ IMMUTABLE LANGUAGE sql;
