CREATE OR REPLACE VIEW api.profiles AS
  SELECT
    id,
    name,
    username,
    avatar,
    COALESCE( if_admin(date_of_birth),   if_user_by_id(user_account_id, date_of_birth)   ) AS date_of_birth,
    COALESCE( if_admin(user_account_id), if_user_by_id(user_account_id, user_account_id) ) AS user_account_id,
    COALESCE( if_admin(interests),       if_user_by_id(user_account_id, interests)       ) AS interests,
    COALESCE( if_admin(preferences),     if_user_by_id(user_account_id, preferences)     ) AS preferences
  FROM app.profiles;

CREATE OR REPLACE FUNCTION triggers.api_profiles_view_instead() RETURNS trigger AS $$
BEGIN
  IF NEW.user_account_id != OLD.user_account_id THEN
    RAISE invalid_authorization_specification USING message = 'could not change user_account_id';
  END IF;

  UPDATE app.profiles
  SET
    name          = NEW.name,
    date_of_birth = NEW.date_of_birth,
    avatar        = NEW.avatar,
    interests     = NEW.interests,
    preferences   = NEW.preferences,
    username      = NEW.username
  WHERE
    id = OLD.id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_profiles_view_instead
  INSTEAD OF UPDATE
  ON api.profiles
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_profiles_view_instead();
