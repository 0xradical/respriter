CREATE TRIGGER resource_increase_sequence
  BEFORE UPDATE
  ON app.resources
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.resource_increase_sequence();

CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.resources
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();

CREATE CONSTRAINT TRIGGER resource_validate_content
  AFTER INSERT OR UPDATE
  ON app.resources
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.resource_validate_content();

CREATE TRIGGER resource_keeps_version
  AFTER INSERT OR UPDATE
  ON app.resources
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.resource_keeps_version();
