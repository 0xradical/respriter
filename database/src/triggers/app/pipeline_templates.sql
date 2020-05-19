CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.pipeline_templates
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
