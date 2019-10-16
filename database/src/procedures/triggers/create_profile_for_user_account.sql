CREATE OR REPLACE FUNCTION triggers.create_profile_for_user_account() RETURNS trigger
AS $$
BEGIN
  INSERT INTO app.profiles (user_account_id) VALUES (NEW.id);
  RETURN NEW;
END
$$ SECURITY DEFINER LANGUAGE plpgsql;
