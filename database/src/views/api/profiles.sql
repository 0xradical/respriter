CREATE OR REPLACE VIEW api.profiles AS
  SELECT
    id,
    name,
    username,
    COALESCE( if_admin(short_bio), if_user_by_id(user_account_id, short_bio) ) AS short_bio,
    COALESCE( if_admin(long_bio), if_user_by_id(user_account_id, long_bio) ) AS long_bio,
    COALESCE( if_admin(instructor), if_user_by_id(user_account_id, instructor) ) AS instructor,
    COALESCE( if_admin(public), if_user_by_id(user_account_id, public) ) AS public,
    COALESCE( if_admin(country), if_user_by_id(user_account_id, country) ) AS country,
    COALESCE( if_admin(website), if_user_by_id(user_account_id, website) ) AS website,
    COALESCE(uploaded_avatar_url, oauth_avatar_url) AS avatar_url,
    COALESCE( if_admin(date_of_birth),   if_user_by_id(user_account_id, date_of_birth)   ) AS date_of_birth,
    user_account_id,
    COALESCE( if_admin(interests),       if_user_by_id(user_account_id, interests)       ) AS interests,
    COALESCE( if_admin(preferences),     if_user_by_id(user_account_id, preferences)     ) AS preferences,
    COALESCE( if_admin(social_profiles), if_user_by_id(user_account_id, social_profiles) ) AS social_profiles,
    COALESCE( if_admin(elearning_profiles), if_user_by_id(user_account_id, elearning_profiles) ) AS elearning_profiles,
    COALESCE( if_admin(course_ids), if_user_by_id(user_account_id, course_ids) ) AS course_ids
  FROM app.profiles;

CREATE OR REPLACE FUNCTION triggers.api_profiles_view_instead() RETURNS trigger AS $$
DECLARE
  exception_sql_state text;
  exception_column_name text;
  exception_constraint_name text;
  exception_table_name text;
  exception_message text;
  exception_detail text;
  exception_hint text;
BEGIN
  IF NEW.user_account_id != OLD.user_account_id THEN
    RAISE invalid_authorization_specification USING message = 'could not change user_account_id';
  END IF;

  IF if_admin(TRUE) IS NULL AND if_user_by_id(NEW.user_account_id, TRUE) IS NULL THEN
    RAISE insufficient_privilege;
  END IF;

  UPDATE app.profiles
  SET
    name                = NEW.name,
    date_of_birth       = NEW.date_of_birth,
    interests           = NEW.interests,
    preferences         = NEW.preferences,
    username            = NEW.username,
    short_bio           = NEW.short_bio,
    long_bio            = NEW.long_bio,
    instructor          = NEW.instructor,
    public              = NEW.public,
    website             = NEW.website,
    country             = NEW.country,
    course_ids          = NEW.course_ids,
    social_profiles     = NEW.social_profiles,
    elearning_profiles  = NEW.elearning_profiles
  WHERE
    id = OLD.id;

  RETURN NEW;
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
    IF exception_sql_state IN ('23514', '23505') AND exception_constraint_name IS NOT NULL THEN
      exception_column_name := REGEXP_REPLACE(exception_constraint_name, '(.*)__(.*)', '\1');
      exception_sql_state := 'constraint';

      exception_detail := (
        CASE exception_column_name
          WHEN 'used_usernames_username_idx' THEN '010001'
          WHEN 'used_usernames_profile_id_username_idx'  THEN '010002'
          ELSE '010000'
        END
      );

    END IF;

    RAISE EXCEPTION '%', exception_message
      USING DETAIL = COALESCE(exception_detail, 'error'), HINT = exception_hint;

  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_profiles_view_instead
  INSTEAD OF UPDATE
  ON api.profiles
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_profiles_view_instead();
