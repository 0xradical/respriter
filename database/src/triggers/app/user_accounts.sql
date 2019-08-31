CREATE TRIGGER encrypt_password
  BEFORE INSERT OR UPDATE
  ON app.user_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.encrypt_password();

CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.user_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();

CREATE TRIGGER create_profile_for_user_account
  AFTER INSERT
  ON app.user_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.create_profile_for_user_account();
