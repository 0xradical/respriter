CREATE OR REPLACE VIEW api.promo_accounts AS
  SELECT
    id,
    COALESCE( if_admin(user_account_id), if_user_by_id(id, user_account_id) ) AS user_account_id,
    COALESCE( if_admin(data),            if_user_by_id(id, data)            ) AS data,
    created_at,
    updated_at
  FROM app.promo_accounts;

CREATE OR REPLACE FUNCTION triggers.api_promo_accounts_view_instead() RETURNS trigger AS $$
DECLARE
  row app.promo_accounts%ROWTYPE;
BEGIN
  row := NEW;

  IF if_admin(TRUE) IS NULL AND if_user_by_id(NEW.user_account_id, TRUE) IS NULL THEN
    RAISE EXCEPTION 'Unauthorized Access';
  END IF;

  INSERT INTO  app.promo_accounts (user_account_id, data)
  VALUES (NEW.user_account_id, NEW.data)
  ON CONFLICT ON CONSTRAINT cntr_promo_accounts_user_account_id DO
    UPDATE SET data = EXCLUDED.data
    RETURNING id, user_account_id, data, created_at, updated_at INTO row;

  RETURN row;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_promo_accounts_view_instead
  INSTEAD OF INSERT
  ON api.promo_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_promo_accounts_view_instead();