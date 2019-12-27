INSERT INTO public.que_jobs (job_class, args)
VALUES ('Pipeline::NotifyJob', array_to_json(ARRAY[($1.id)::varchar]));

UPDATE app.resources
SET content = content || jsonb_build_object('published', false)
WHERE
  content->>'provider_name'     = $1.data->>'provider_name'
  AND content->>'published'     = 'true'
  AND content->>'execution_id' != ($1.pipeline_execution_id)::varchar;