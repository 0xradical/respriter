CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.profiles
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();

CREATE TRIGGER use_username
  AFTER INSERT OR UPDATE
  ON app.profiles
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.use_username();
