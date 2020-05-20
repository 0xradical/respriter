CREATE OR REPLACE FUNCTION triggers.use_username() RETURNS trigger
AS $$
BEGIN
  IF (TG_OP = 'INSERT' AND NEW.username IS NULL) THEN
    RAISE EXCEPTION 'username update failed' USING DETAIL = 'username__cannot_be_null';
  END IF;

  IF (TG_OP = 'UPDATE' AND OLD.username IS NULL AND NEW.username IS NULL) THEN
    RETURN NEW;
  END IF;

  IF TG_OP = 'UPDATE' AND OLD.username IS NOT NULL AND NEW.username IS NULL THEN
    RAISE EXCEPTION 'username update failed' USING DETAIL = 'username__cannot_be_erased';
  END IF;

  IF ((TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND OLD.username IS NULL)) AND NEW.username IS NOT NULL) OR
     (TG_OP = 'UPDATE' AND OLD.username IS NOT NULL AND NEW.username IS NOT NULL AND OLD.username <> NEW.username) THEN

    IF TG_OP = 'UPDATE' AND OLD.username_changed_at IS NOT NULL AND
      (NOW() - OLD.username_changed_at < '15 days'::interval) THEN
      RAISE EXCEPTION 'username update failed' USING DETAIL = 'username__change_within_update_threshold', HINT = json_build_object('threshold', '15');
    ELSE
      UPDATE app.profiles SET username_changed_at = NOW() WHERE id = NEW.id;
    END IF;

    INSERT INTO app.used_usernames (profile_id, username) VALUES (NEW.id, NEW.username);

    RETURN NEW;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;