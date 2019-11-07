CREATE OR REPLACE FUNCTION triggers.validate_user_account_ids() RETURNS trigger AS $$
DECLARE
  result boolean;
BEGIN
  IF NEW.user_account_ids = OLD.user_account_ids THEN
    RETURN NEW;
  END IF;

  result = NOT EXISTS (
    SELECT 1 FROM unnest(NEW.user_account_ids) AS provider_user_account_id
    WHERE NOT EXISTS (
      SELECT 1 FROM app.user_accounts
      WHERE
        provider_user_account_id = app.user_accounts.id
    )
  );

  IF result = false THEN
    RAISE EXCEPTION 'Invalid user_account_ids' USING HINT = 'All user account ids must exists';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
