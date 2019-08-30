BEGIN;

CREATE OR REPLACE FUNCTION api.admin_login(
  email    varchar,
  password varchar
) RETURNS text
AS $$
DECLARE
  admin_id bigint;
  result   text;
BEGIN
  SELECT
    id
  FROM api.admin_accounts
  WHERE
    api.admin_accounts.email              = admin_login.email AND
    api.admin_accounts.encrypted_password = public.crypt(admin_login.password, api.admin_accounts.encrypted_password)
  INTO admin_id;

  IF admin_id IS NULL THEN
    RAISE invalid_password USING message = 'invalid email or password';
  END IF;

  SELECT
    jwt.sign(
      row_to_json(r), settings.get('app.jwt_secret')
    ) AS token
  FROM (
    SELECT
      'admin'                                AS role,
      admin_id::varchar                      AS sub,
      extract(EPOCH FROM now())::int + 60*60 AS exp
  ) r
  INTO result;

  RETURN result;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;

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
  FROM api.user_accounts
  WHERE
    api.user_accounts.email              = user_login.email AND
    api.user_accounts.encrypted_password = public.crypt(user_login.password, api.user_accounts.encrypted_password)
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


COMMIT;
