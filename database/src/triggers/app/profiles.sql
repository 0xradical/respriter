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

CREATE TRIGGER validate_profiles
  BEFORE INSERT OR UPDATE
  ON app.profiles
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.validate_profiles();

CREATE TRIGGER validate_website
  BEFORE INSERT OR UPDATE
  ON app.profiles
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.validate_website();