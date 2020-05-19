CREATE OR REPLACE FUNCTION api.login(
  username varchar,
  password varchar,
  days     int DEFAULT 1
) RETURNS text
AS $$
DECLARE
  _user  record;
  result text;
BEGIN
  SELECT
    *
  FROM app.users
  WHERE
    app.users.username = login.username AND
    app.users.password = public.crypt(login.password, app.users.password)
  INTO _user;

  IF NOT FOUND THEN
    RAISE invalid_password USING message = 'invalid username or password';
  END IF;

  SELECT
    jwt.sign(
      row_to_json(r), settings.get('app.jwt_secret')
    ) AS token
  FROM (
    SELECT
      'user'                                        AS role,
      _user.dataset_id::varchar                     AS dataset,
      _user.id::varchar                             AS sub,
      extract(EPOCH FROM now())::int + days*24*3600 AS exp
  ) r
  INTO result;

  RETURN result;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
