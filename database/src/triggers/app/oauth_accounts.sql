CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.oauth_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
