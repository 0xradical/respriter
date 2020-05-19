CREATE FUNCTION triggers.pipeline_execution_schedule_next()
RETURNS trigger AS $$
BEGIN
  IF OLD.status != NEW.status AND NEW.status = 'succeeded' AND NEW.schedule_interval IS NOT NULL THEN
    INSERT INTO app.pipeline_executions (
      dataset_id,
      pipeline_template_id,
      schedule_interval,
      counter,
      name
    ) VALUES (
      NEW.dataset_id,
      NEW.pipeline_template_id,
      NEW.schedule_interval,
      NEW.counter + 1,
      NEW.name
    );
  END IF;

  RETURN NEW;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
