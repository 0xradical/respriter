CREATE FUNCTION triggers.course_normalize_languages() RETURNS trigger AS $$
BEGIN
  NEW.audio     = app.normalize_languages(NEW.audio);
  NEW.subtitles = app.normalize_languages(NEW.subtitles);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
