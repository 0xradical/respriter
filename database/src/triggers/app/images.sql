CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.images
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
