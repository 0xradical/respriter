CREATE OR REPLACE FUNCTION api.user_login(
  email    varchar,
  password varchar
) RETURNS text
AS $$
DECLARE
  user_id bigint;
  result  text;
BEGIN
  SELECT
    id
  FROM app.user_accounts
  WHERE
    app.user_accounts.email              = user_login.email AND
    app.user_accounts.encrypted_password = public.crypt(user_login.password, app.user_accounts.encrypted_password)
  INTO user_id;

  IF user_id IS NULL THEN
    RAISE invalid_password USING message = 'invalid user or password';
  END IF;

  SELECT
    jwt.sign(
      row_to_json(r), settings.get('app.jwt_secret')
    ) AS token
  FROM (
    SELECT
      'user'                                 AS role,
      user_id::varchar                       AS sub,
      extract(EPOCH FROM now())::int + 60*60 AS exp
  ) r
  INTO result;

  RETURN result;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
