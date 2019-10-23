CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.course_reviews
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();