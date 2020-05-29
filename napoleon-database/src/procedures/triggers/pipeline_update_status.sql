CREATE FUNCTION triggers.pipeline_update_status()
RETURNS trigger AS $$
BEGIN
  IF NEW.total_count <= 0 OR (NEW.succeeded_count + NEW.failed_count + NEW.waiting_count != NEW.total_count) THEN
    NEW.status = 'pending';
  ELSE
    IF NEW.waiting_count > 0 THEN
      NEW.status = 'waiting';
    END IF;

    IF NEW.failed_count > 0 THEN
      NEW.status = 'failed';
    END IF;

    IF NEW.succeeded_count = NEW.total_count THEN
      NEW.status = 'succeeded';
    END IF;
  END IF;

  RETURN NEW;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
