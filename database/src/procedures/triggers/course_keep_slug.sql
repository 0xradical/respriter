CREATE FUNCTION triggers.course_keep_slug() RETURNS trigger AS $$
BEGIN
  IF (NEW.published = false) THEN
    RETURN NEW;
  END IF;

  INSERT INTO app.slug_histories (
    course_id, slug
  ) VALUES (
    NEW.id, NEW.slug
  ) ON CONFLICT DO NOTHING;

  RETURN NEW;
END
$$ SECURITY DEFINER LANGUAGE plpgsql;
