CREATE INDEX que_jobs_args_gin_idx
ON public.que_jobs
USING gin (args jsonb_path_ops);

CREATE INDEX que_jobs_data_gin_idx
ON public.que_jobs
USING gin (data jsonb_path_ops);

CREATE INDEX que_poll_idx
ON public.que_jobs
USING btree (queue, priority, run_at, id)
WHERE ((finished_at IS NULL) AND (expired_at IS NULL));
