CREATE OR REPLACE VIEW api.user_accounts AS
  SELECT
    id,
    email,
    NULL::varchar                                                                           AS password,
    COALESCE( if_admin(reset_password_token),   if_user_by_id(id, reset_password_token)   ) AS reset_password_token,
    COALESCE( if_admin(reset_password_sent_at), if_user_by_id(id, reset_password_sent_at) ) AS reset_password_sent_at,
    COALESCE( if_admin(remember_created_at),    if_user_by_id(id, remember_created_at)    ) AS remember_created_at,
    COALESCE( if_admin(sign_in_count),          if_user_by_id(id, sign_in_count)          ) AS sign_in_count,
    COALESCE( if_admin(current_sign_in_at),     if_user_by_id(id, current_sign_in_at)     ) AS current_sign_in_at,
    COALESCE( if_admin(last_sign_in_at),        if_user_by_id(id, last_sign_in_at)        ) AS last_sign_in_at,
    COALESCE( if_admin(current_sign_in_ip),     if_user_by_id(id, current_sign_in_ip)     ) AS current_sign_in_ip,
    COALESCE( if_admin(last_sign_in_ip),        if_user_by_id(id, last_sign_in_ip)        ) AS last_sign_in_ip,
    COALESCE( if_admin(tracking_data),          if_user_by_id(id, tracking_data)          ) AS tracking_data,
    COALESCE( if_admin(confirmation_token),     if_user_by_id(id, confirmation_token)     ) AS confirmation_token,
    COALESCE( if_admin(confirmed_at),           if_user_by_id(id, confirmed_at)           ) AS confirmed_at,
    COALESCE( if_admin(confirmation_sent_at),   if_user_by_id(id, confirmation_sent_at)   ) AS confirmation_sent_at,
    COALESCE( if_admin(unconfirmed_email),      if_user_by_id(id, unconfirmed_email)      ) AS unconfirmed_email,
    COALESCE( if_admin(failed_attempts),        if_user_by_id(id, failed_attempts)        ) AS failed_attempts,
    COALESCE( if_admin(unlock_token),           if_user_by_id(id, unlock_token)           ) AS unlock_token,
    COALESCE( if_admin(locked_at),              if_user_by_id(id, locked_at)              ) AS locked_at,
    COALESCE( if_admin(destroyed_at),           if_user_by_id(id, destroyed_at)           ) AS destroyed_at,
    created_at,
    updated_at
  FROM app.user_accounts;

CREATE OR REPLACE FUNCTION triggers.api_user_accounts_view_instead() RETURNS trigger AS $$
BEGIN
  UPDATE app.user_accounts
  SET
    email              = NEW.email,
    encrypted_password = crypt(NEW.password, gen_salt('bf', 11))
  WHERE
    id = OLD.id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_user_accounts_view_instead
  INSTEAD OF UPDATE
  ON api.user_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_user_accounts_view_instead();
