CREATE TRIGGER que_job_notify
  AFTER INSERT
  ON public.que_jobs
  FOR EACH ROW
    EXECUTE PROCEDURE public.que_job_notify();

CREATE TRIGGER que_state_notify
  AFTER INSERT OR DELETE OR UPDATE
  ON public.que_jobs
  FOR EACH ROW
    EXECUTE PROCEDURE public.que_state_notify();
