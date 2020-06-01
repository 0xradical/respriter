CREATE FUNCTION triggers.pipeline_execution_schedule_itself()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.que_jobs (
    job_class,
    args,
    run_at
  ) VALUES (
    'PipelineExecution::CallJob',
    jsonb_build_array(NEW.id::varchar),
    COALESCE(
      NEW.run_at,
      NOW() + COALESCE(NEW.schedule_interval, '0 seconds'::interval)
    )
  );

  RETURN NEW;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
