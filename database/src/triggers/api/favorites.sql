CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON api.favorites
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
