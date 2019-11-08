CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.preview_courses
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
