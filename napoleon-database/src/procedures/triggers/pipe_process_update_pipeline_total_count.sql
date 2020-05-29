CREATE FUNCTION triggers.pipe_process_update_pipeline_total_count()
RETURNS trigger AS $$
BEGIN
  UPDATE app.pipelines
  SET
    total_count = total_count + 1
  WHERE
    id = NEW.pipeline_id;

  RETURN NEW;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
