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
