CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.posts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
