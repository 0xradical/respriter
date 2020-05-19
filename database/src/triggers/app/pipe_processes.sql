CREATE TRIGGER pipe_process_update_pipeline_total_count
  AFTER INSERT
  ON app.pipe_processes
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.pipe_process_update_pipeline_total_count();

CREATE TRIGGER pipe_process_update_pipeline_counters
  AFTER UPDATE
  ON app.pipe_processes
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.pipe_process_update_pipeline_counters();

CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.pipe_processes
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();

CREATE TRIGGER pipe_process_delete_que_jobs
  AFTER DELETE
  ON app.pipe_processes
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.pipe_process_delete_que_jobs();
