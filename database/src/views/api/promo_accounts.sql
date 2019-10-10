CREATE OR REPLACE VIEW api.promo_accounts AS
  SELECT
    app.promo_accounts.id AS id,
    COALESCE( if_admin(app.promo_accounts.user_account_id), if_user_by_id(app.promo_accounts.user_account_id, app.promo_accounts.user_account_id) ) AS user_account_id,
    COALESCE( if_admin(certificate_id),  if_user_by_id(app.promo_accounts.user_account_id, certificate_id)  ) AS certificate_id,
    COALESCE( if_admin(price),           if_user_by_id(app.promo_accounts.user_account_id, price)           ) AS price,
    COALESCE( if_admin(purchase_date),   if_user_by_id(app.promo_accounts.user_account_id, purchase_date)   ) AS purchase_date,
    COALESCE( if_admin(order_id),        if_user_by_id(app.promo_accounts.user_account_id, order_id)        ) AS order_id,
    COALESCE( if_admin(paypal_account),  if_user_by_id(app.promo_accounts.user_account_id, paypal_account)  ) AS paypal_account,
    COALESCE( if_admin(state),           if_user_by_id(app.promo_accounts.user_account_id, state)           ) AS state,
    COALESCE( if_admin(state_info),      if_user_by_id(app.promo_accounts.user_account_id, state_info)      ) AS state_info,
    COALESCE( if_admin(file),            if_user_by_id(app.promo_accounts.user_account_id, file)            ) AS file,
    app.promo_accounts.created_at,
    app.promo_accounts.updated_at
  FROM app.promo_accounts
  INNER JOIN app.certificates ON app.promo_accounts.certificate_id = app.certificates.id;

CREATE OR REPLACE FUNCTION triggers.api_promo_accounts_view_instead() RETURNS trigger AS $$
DECLARE
  cert_id uuid;
  cert_user_account_id bigint;
  cert_file varchar;
  promo_account record;
  exception_sql_state text;
  exception_column_name text;
  exception_constraint_name text;
  exception_table_name text;
  exception_message text;
  exception_detail text;
  exception_hint text;
BEGIN
  promo_account := NEW;

  IF TG_OP = 'INSERT' THEN
    SELECT current_setting('request.header.certificateid', true)::uuid INTO cert_id;
  ELSIF (TG_OP = 'UPDATE' AND if_admin(TRUE) IS NOT NULL) THEN
    cert_id := OLD.certificate_id;
  END IF;

  IF cert_id IS NULL THEN
    RAISE EXCEPTION 'Null certificate'
      USING DETAIL = 'error', HINT = 'promo_accounts.certificate_id.null';
  END IF;

  SELECT app.certificates.user_account_id FROM app.certificates WHERE id = cert_id INTO cert_user_account_id;

  IF if_admin(TRUE) IS NULL AND if_user_by_id(cert_user_account_id, TRUE) IS NULL THEN
    RAISE insufficient_privilege
      USING DETAIL = 'error', HINT = 'promo_accounts.user_account_id.mismatch';
  END IF;

  IF if_admin(TRUE) IS NULL AND if_user_by_id(promo_account.user_account_id, TRUE) IS NULL THEN
    RAISE insufficient_privilege
      USING DETAIL = 'error', HINT = 'promo_accounts.unauthorized';
  END IF;

  SELECT app.certificates.file FROM app.certificates WHERE id = cert_id INTO cert_file;

  IF (TG_OP = 'INSERT') THEN
    INSERT INTO app.promo_accounts (id, user_account_id, certificate_id, price, purchase_date, order_id, paypal_account, state)
    VALUES (COALESCE(promo_account.id, public.uuid_generate_v4()), promo_account.user_account_id, cert_id, promo_account.price, promo_account.purchase_date, promo_account.order_id, promo_account.paypal_account, 'pending')
    ON CONFLICT ON CONSTRAINT cntr_promo_accounts_user_account_id DO
      UPDATE SET certificate_id = EXCLUDED.certificate_id,
                 price = COALESCE(EXCLUDED.price, app.promo_accounts.price),
                 purchase_date = COALESCE(EXCLUDED.purchase_date, app.promo_accounts.purchase_date),
                 order_id = COALESCE(EXCLUDED.order_id, app.promo_accounts.order_id),
                 paypal_account = COALESCE(EXCLUDED.paypal_account, app.promo_accounts.paypal_account),
                 old_self = (SELECT json_agg(json_build_object('price', apc.price, 'purchase_date', apc.purchase_date, 'order_id', apc.order_id, 'paypal_account', apc.paypal_account, 'state', apc.state, 'state_info', apc.state_info))->>0 FROM app.promo_accounts AS apc where apc.id = id)::jsonb
      RETURNING * INTO promo_account;
  ELSIF (TG_OP = 'UPDATE' AND if_admin(TRUE) IS NOT NULL) THEN
    UPDATE app.promo_accounts
       SET state = COALESCE(NEW.state, OLD.state),
           state_info = CASE NEW.state = OLD.state AND NEW.state = 'rejected'
                        WHEN TRUE THEN
                          COALESCE(NEW.state_info, OLD.state_info)
                        ELSE
                          NEW.state_info
                        END,
           old_self = (SELECT json_agg(json_build_object('price', apc.price, 'purchase_date', apc.purchase_date, 'order_id', apc.order_id, 'paypal_account', apc.paypal_account, 'state', apc.state, 'state_info', apc.state_info))->>0 FROM app.promo_accounts AS apc where apc.id = id)::jsonb
        RETURNING * INTO promo_account;
  END IF;

  IF if_admin(TRUE) IS NULL AND promo_account.state IN ('locked', 'approved') THEN
    RAISE EXCEPTION 'Cannot update on locked promo'
      USING DETAIL = 'error', HINT = 'promo_accounts.state.locked';
  END IF;

  IF promo_account.state = 'rejected' AND promo_account.state_info IS NULL THEN
    RAISE EXCEPTION 'Rejected promo cannot have empty state_info'
      USING DETAIL = 'error', HINT = 'promo_accounts.state_info.blank';
  END IF;

  INSERT INTO app.promo_account_logs (promo_account_id, old, new, role)
    VALUES (promo_account.id, promo_account.old_self, json_build_object('price', promo_account.price, 'purchase_date', promo_account.purchase_date, 'order_id', promo_account.order_id, 'paypal_account', promo_account.paypal_account, 'state', promo_account.state, 'state_info', promo_account.state_info), current_user);

  RETURN (
    promo_account.id,
    promo_account.user_account_id,
    promo_account.certificate_id,
    promo_account.price,
    promo_account.purchase_date,
    promo_account.order_id,
    promo_account.paypal_account,
    promo_account.state,
    promo_account.state_info,
    cert_file,
    promo_account.created_at,
    promo_account.updated_at
  );
EXCEPTION
  WHEN insufficient_privilege THEN
    RAISE;
  WHEN OTHERS THEN
  GET STACKED DIAGNOSTICS exception_message = MESSAGE_TEXT,
                          exception_detail = PG_EXCEPTION_DETAIL,
                          exception_hint = PG_EXCEPTION_HINT,
                          exception_sql_state = RETURNED_SQLSTATE,
                          exception_column_name = COLUMN_NAME,
                          exception_constraint_name = CONSTRAINT_NAME,
                          exception_table_name = TABLE_NAME;

  IF exception_detail = 'error' THEN
    RAISE EXCEPTION '%', exception_message
      USING DETAIL = exception_detail, HINT = exception_hint;
  ELSE
    -- constraint
    IF exception_sql_state = '23514' AND exception_constraint_name IS NOT NULL THEN
      exception_column_name := REGEXP_REPLACE(exception_constraint_name, '(.*)__(.*)', '\1');
    END IF;

    RAISE EXCEPTION '%', exception_message
      USING DETAIL = 'error', HINT = 'promo_accounts.' || exception_column_name || '.' || exception_sql_state;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_promo_accounts_view_instead
  INSTEAD OF INSERT OR UPDATE
  ON api.promo_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_promo_accounts_view_instead();
