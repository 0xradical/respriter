CREATE FUNCTION triggers.pipe_process_delete_que_jobs()
RETURNS trigger AS $$
BEGIN
  DELETE FROM public.que_jobs
  WHERE
    job_class IN ('PipeProcess::CallJob', 'PipeProcess::RetryJob')
    AND args->>0 = OLD.id::varchar;

  RETURN OLD;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
