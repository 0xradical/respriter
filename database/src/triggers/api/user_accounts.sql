CREATE TRIGGER encrypt_password
  BEFORE INSERT OR UPDATE
  ON api.user_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.encrypt_password();

CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON api.user_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
