CREATE OR REPLACE VIEW api.promo_accounts AS
  SELECT
    id,
    COALESCE( if_admin(data),            if_user_by_id(id, data)            ) AS data,
    COALESCE( if_admin(user_account_id), if_user_by_id(id, user_account_id) ) AS user_account_id,
    created_at,
    updated_at
  FROM app.promo_accounts;

CREATE OR REPLACE FUNCTION triggers.api_promo_accounts_view_instead() RETURNS trigger AS $$
BEGIN
  UPDATE app.promo_accounts
  SET
    data = NEW.data
  WHERE
    id = OLD.id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_promo_accounts_view_instead
  INSTEAD OF UPDATE
  ON api.promo_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_promo_accounts_view_instead();
