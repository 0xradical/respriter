CREATE TRIGGER encrypt_password
  BEFORE INSERT OR UPDATE
  ON app.admin_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.encrypt_password();

CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.admin_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
