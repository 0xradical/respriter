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
  FROM app.admin_accounts
  WHERE
    app.admin_accounts.email              = admin_login.email AND
    app.admin_accounts.encrypted_password = public.crypt(admin_login.password, app.admin_accounts.encrypted_password)
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
