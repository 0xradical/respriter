CREATE FUNCTION jwt.algorithm_sign(
  signables text,
  secret    text,
  algorithm text
) RETURNS text
AS $$
  WITH
    alg AS ( SELECT
      CASE
      WHEN algorithm = 'HS256' THEN 'sha256'
      WHEN algorithm = 'HS384' THEN 'sha384'
      WHEN algorithm = 'HS512' THEN 'sha512'
      ELSE ''
      END
    )  -- hmac throws error
  SELECT jwt.url_encode(public.hmac(signables, secret, (select * FROM alg)));
$$ LANGUAGE sql;
