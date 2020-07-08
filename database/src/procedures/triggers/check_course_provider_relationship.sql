CREATE FUNCTION triggers.check_course_provider_relationship() RETURNS trigger AS $$
BEGIN
  IF (NEW.course_id IS NOT NULL) THEN
    IF (NEW.provider_id IS NOT NULL) THEN
      IF (SELECT provider_id FROM app.courses WHERE id = NEW.course_id) <> NEW.provider_id THEN
        RAISE EXCEPTION 'update failed' USING DETAIL = 'course_provider__do_not_match', HINT = json_build_object('course_id', NEW.course_id, 'provider_id', NEW.provider_id);
      END IF;
    ELSE
      NEW.provider_id := (SELECT provider_id FROM app.courses WHERE id = NEW.course_id);
    END IF;
  END IF;

  RETURN NEW;
END
$$ SECURITY DEFINER LANGUAGE plpgsql;