CREATE TRIGGER pipeline_setup_from_template
  BEFORE INSERT
  ON app.pipelines
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.pipeline_setup_from_template();

CREATE TRIGGER pipeline_invoke_bootstrap
  AFTER INSERT
  ON app.pipelines
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.pipeline_invoke_bootstrap();

CREATE TRIGGER pipeline_update_status
  BEFORE UPDATE
  ON app.pipelines
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.pipeline_update_status();

CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.pipelines
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();

CREATE TRIGGER pipeline_invoke_status_callback
  AFTER UPDATE
  ON app.pipelines
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.pipeline_invoke_status_callback();

CREATE TRIGGER pipeline_delete_que_jobs
  AFTER DELETE
  ON app.pipelines
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.pipeline_delete_que_jobs();
