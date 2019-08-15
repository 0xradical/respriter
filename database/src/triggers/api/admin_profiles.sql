CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON api.admin_profiles
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
