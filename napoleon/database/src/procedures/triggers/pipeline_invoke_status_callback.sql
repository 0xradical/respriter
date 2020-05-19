CREATE FUNCTION triggers.pipeline_invoke_status_callback()
RETURNS trigger AS $$
BEGIN
  IF OLD.status = NEW.status THEN
    RETURN NEW;
  END IF;

  CASE NEW.status
  WHEN 'succeeded' THEN
    CASE WHEN NEW.success_script_type IS NULL THEN
      INSERT INTO public.que_jobs (job_class, args)
      VALUES ('Pipeline::NotifyJob', array_to_json(ARRAY[NEW.id]));
    ELSE
      PERFORM app.invoke_sql_or_enqueue_job(
        NEW.success_script,
        NEW.success_script_type,
        'Pipeline::SuccessJob',
        NEW
      );
    END CASE;

  WHEN 'failed' THEN
    CASE WHEN NEW.fail_script_type IS NULL THEN
      INSERT INTO public.que_jobs (job_class, args)
      VALUES ('Pipeline::NotifyJob', array_to_json(ARRAY[NEW.id]));
    ELSE
      PERFORM app.invoke_sql_or_enqueue_job(
        NEW.fail_script,
        NEW.fail_script_type,
        'Pipeline::FailJob',
        NEW
      );
    END CASE;
  WHEN 'waiting' THEN
    CASE WHEN NEW.waiting_script_type IS NULL THEN
      INSERT INTO public.que_jobs (job_class, args)
      VALUES ('Pipeline::NotifyJob', array_to_json(ARRAY[NEW.id]));
    ELSE
      PERFORM app.invoke_sql_or_enqueue_job(
        NEW.waiting_script,
        NEW.waiting_script_type,
        'Pipeline::WaitingJob',
        NEW
      );
    END CASE;
  ELSE
  END CASE;

  IF NEW.status != OLD.status THEN
    PERFORM app.pipeline_execution_update_status(NEW.pipeline_execution_id);
  END IF;

  RETURN NEW;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
