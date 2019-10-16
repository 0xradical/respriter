CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.providers
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
