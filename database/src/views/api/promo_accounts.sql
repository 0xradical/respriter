CREATE OR REPLACE VIEW api.promo_accounts AS
  SELECT
    id,
    COALESCE( if_admin(user_account_id), if_user_by_id(id, user_account_id) ) AS user_account_id,
    COALESCE( if_admin(price),           if_user_by_id(id, price)           ) AS price,
    COALESCE( if_admin(purchase_date),   if_user_by_id(id, purchase_date)   ) AS purchase_date,
    COALESCE( if_admin(order_id),        if_user_by_id(id, order_id)        ) AS order_id,
    COALESCE( if_admin(paypal_account),  if_user_by_id(id, paypal_account)  ) AS paypal_account,
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

  INSERT INTO  app.promo_accounts (user_account_id, price, purchase_date, order_id, paypal_account)
  VALUES (NEW.user_account_id, NEW.price, NEW.purchase_date, NEW.order_id, NEW.paypal_account)
  ON CONFLICT ON CONSTRAINT cntr_promo_accounts_user_account_id DO
    UPDATE SET price = EXCLUDED.price,
               purchase_date = EXCLUDED.purchase_date,
               order_id = EXCLUDED.order_id,
               paypal_account = EXCLUDED.paypal_account
    RETURNING id, user_account_id, price, purchase_date, order_id, paypal_account, created_at, updated_at INTO row;

  RETURN row;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_promo_accounts_view_instead
  INSTEAD OF INSERT
  ON api.promo_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_promo_accounts_view_instead();