CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.slug_histories
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
