CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.resource_schemas
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
