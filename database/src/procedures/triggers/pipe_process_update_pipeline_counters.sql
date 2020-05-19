CREATE FUNCTION triggers.pipe_process_update_pipeline_counters()
RETURNS trigger AS $$
DECLARE
  waiting_increment   int;
  failed_increment    int;
  succeeded_increment int;
BEGIN
  IF ( OLD.status = NEW.status                               ) OR
     ( OLD.status = 'skipped'   AND NEW.status = 'succeeded' ) OR
     ( OLD.status = 'succeeded' AND NEW.status = 'skipped'   ) THEN
    RETURN NEW;
  END IF;

  waiting_increment   = 0;
  failed_increment    = 0;
  succeeded_increment = 0;

  CASE OLD.status
  WHEN 'waiting' THEN
    waiting_increment = -1;
  WHEN 'failed' THEN
    failed_increment = -1;
  WHEN 'skipped' THEN
    succeeded_increment = -1;
  WHEN 'succeeded' THEN
    succeeded_increment = -1;
  ELSE
  END CASE;

  CASE NEW.status
  WHEN 'waiting' THEN
    waiting_increment = waiting_increment + 1;
  WHEN 'failed' THEN
    failed_increment = failed_increment + 1;
  WHEN 'skipped' THEN
    succeeded_increment = succeeded_increment + 1;
  WHEN 'succeeded' THEN
    succeeded_increment = succeeded_increment + 1;
  ELSE
  END CASE;

  UPDATE app.pipelines
  SET
    waiting_count   = waiting_count   + waiting_increment,
    failed_count    = failed_count    + failed_increment,
    succeeded_count = succeeded_count + succeeded_increment
  WHERE
    id = NEW.pipeline_id;

  RETURN NEW;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
