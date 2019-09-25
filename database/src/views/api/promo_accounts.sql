CREATE OR REPLACE VIEW api.promo_accounts AS
  SELECT
    id,
    COALESCE( if_admin(user_account_id), if_user_by_id(user_account_id, user_account_id) ) AS user_account_id,
    COALESCE( if_admin(price),           if_user_by_id(user_account_id, price)           ) AS price,
    COALESCE( if_admin(purchase_date),   if_user_by_id(user_account_id, purchase_date)   ) AS purchase_date,
    COALESCE( if_admin(order_id),        if_user_by_id(user_account_id, order_id)        ) AS order_id,
    COALESCE( if_admin(paypal_account),  if_user_by_id(user_account_id, paypal_account)  ) AS paypal_account,
    created_at,
    updated_at
  FROM app.promo_accounts;

CREATE OR REPLACE FUNCTION triggers.api_promo_accounts_view_instead() RETURNS trigger AS $$
DECLARE
  promo_account app.promo_accounts%ROWTYPE;
  promo_account_certificate app.promo_account_certificates%ROWTYPE;
  promo_account_certificate_id uuid;
  promo_account_certificate_user_id bigint;
BEGIN
  promo_account := NEW;

  SELECT current_setting('request.header.certificateid', true)::uuid INTO promo_account_certificate_id;

  IF promo_account_certificate_id IS NULL THEN
    RAISE EXCEPTION 'Null certificate';
  END IF;

  SELECT app.certificates.user_account_id FROM app.certificates WHERE id = promo_account_certificate_id INTO promo_account_certificate_user_id;

  IF if_admin(TRUE) IS NULL AND if_user_by_id(promo_account_certificate_user_id, TRUE) IS NULL THEN
    RAISE EXCEPTION 'Unauthorized Access';
  END IF;

  IF if_admin(TRUE) IS NULL AND if_user_by_id(NEW.user_account_id, TRUE) IS NULL THEN
    RAISE EXCEPTION 'Unauthorized Access';
  END IF;

  INSERT INTO  app.promo_accounts (id, user_account_id, price, purchase_date, order_id, paypal_account)
  VALUES (NEW.id, NEW.user_account_id, NEW.price, NEW.purchase_date, NEW.order_id, NEW.paypal_account)
  ON CONFLICT ON CONSTRAINT cntr_promo_accounts_user_account_id DO
    UPDATE SET price = EXCLUDED.price,
              purchase_date = EXCLUDED.purchase_date,
              order_id = EXCLUDED.order_id,
              paypal_account = EXCLUDED.paypal_account
    RETURNING id, user_account_id, price, purchase_date, order_id, paypal_account, created_at, updated_at INTO promo_account;

  INSERT INTO app.promo_account_certificates (promo_account_id, certificate_id, state)
  VALUES (promo_account.id, promo_account_certificate_id, 'pending')
  ON CONFLICT ON CONSTRAINT cntr_promo_account_certificates_promo_account_id DO
    UPDATE SET certificate_id = EXCLUDED.certificate_id
    RETURNING id, promo_account_id, certificate_id, state INTO promo_account_certificate;

  IF promo_account_certificate.state IN ('locked', 'approved') THEN
    RAISE EXCEPTION 'Cannot update on locked promo';
  END IF;

  RETURN promo_account;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_promo_accounts_view_instead
  INSTEAD OF INSERT
  ON api.promo_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_promo_accounts_view_instead();