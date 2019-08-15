CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON api.images
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
