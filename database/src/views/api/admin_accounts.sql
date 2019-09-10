CREATE OR REPLACE VIEW api.admin_accounts AS
  SELECT
    id,
    email,
    NULL::varchar AS password,
    reset_password_token,
    reset_password_sent_at,
    remember_created_at,
    sign_in_count,
    current_sign_in_at,
    last_sign_in_at,
    current_sign_in_ip,
    last_sign_in_ip,
    confirmation_token,
    confirmed_at,
    confirmation_sent_at,
    unconfirmed_email,
    failed_attempts,
    unlock_token,
    locked_at,
    created_at,
    updated_at,
    preferences
  FROM app.admin_accounts;

CREATE OR REPLACE FUNCTION triggers.api_admin_accounts_view_instead() RETURNS trigger AS $$
BEGIN
  IF (TG_OP = 'UPDATE') THEN
    UPDATE app.admin_accounts
    SET
      email              = NEW.email,
      encrypted_password = crypt(NEW.password, gen_salt('bf', 11))
    WHERE
      id = OLD.id;
  ELSIF (TG_OP = 'INSERT') THEN
    INSERT INTO app.admin_accounts (
      email,
      encrypted_password
    ) VALUES (
      NEW.email,
      crypt(NEW.password, gen_salt('bf', 11))
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_admin_accounts_view_instead
  INSTEAD OF INSERT OR UPDATE
  ON api.admin_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_admin_accounts_view_instead();
