INSERT INTO public.que_jobs (job_class, args)
VALUES ('Pipeline::NotifyJob', array_to_json(ARRAY[($1.id)::varchar]));

WITH removed_courses AS (
  UPDATE app.resources
  SET content = content || jsonb_build_object('published', false)
  WHERE
    content->>'provider_id'   = $1.data->>'provider_id'
    AND content->>'published' = 'true'
    AND last_execution_id     != $1.pipeline_execution_id
  RETURNING id
)

SELECT COUNT(*) FROM removed_courses;

INSERT INTO app.pipe_processes (
  pipeline_execution_id,
  pipeline_id,
  initial_accumulator
) SELECT
  $1.pipeline_execution_id,
  ($1.data->>'crawling_events_pipeline_id')::uuid,
  accumulator
FROM app.pipe_processes
WHERE
  pipeline_id = $1.id
  AND status = 'skipped'
  AND accumulator ? 'crawling_event';

SELECT app.pipeline_call(($1.data->>'next_pipeline_id')::uuid);
