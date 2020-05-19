CREATE TRIGGER pipeline_execution_schedule_itself
  AFTER INSERT
  ON app.pipeline_executions
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.pipeline_execution_schedule_itself();

CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.pipeline_executions
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();

CREATE TRIGGER pipeline_execution_schedule_next
  AFTER UPDATE
  ON app.pipeline_executions
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.pipeline_execution_schedule_next();

CREATE TRIGGER pipeline_execution_delete_que_jobs
  AFTER DELETE
  ON app.pipeline_executions
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.pipeline_execution_delete_que_jobs();
