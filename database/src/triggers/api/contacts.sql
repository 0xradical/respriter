CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON api.contacts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
