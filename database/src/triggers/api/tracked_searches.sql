CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON api.tracked_searches
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
