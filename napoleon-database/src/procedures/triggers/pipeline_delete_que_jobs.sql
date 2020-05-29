CREATE FUNCTION triggers.pipeline_delete_que_jobs()
RETURNS trigger AS $$
BEGIN
  DELETE FROM public.que_jobs
  WHERE
    job_class IN ('Pipeline::BootstrapJob', 'Pipeline::WaitingJob', 'Pipeline::SuccessJob', 'Pipeline::FailJob', 'Pipeline::NotifyJob')
    AND args->>0 = OLD.id::varchar;

  RETURN OLD;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
