CREATE TRIGGER user_encrypt_password
  BEFORE INSERT OR UPDATE
  ON app.users
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.user_encrypt_password();

CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.users
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
