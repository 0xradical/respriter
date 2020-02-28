INSERT INTO app.pipe_processes (
  pipeline_id,
  initial_accumulator
) SELECT
  ($1.data->>'crawling_events_pipeline_id')::uuid,
  accumulator
FROM app.pipe_processes
WHERE
  pipeline_id = $1.id
  AND status  = 'skipped'
  AND accumulator ? 'crawling_event';

INSERT INTO app.pipe_processes (
  pipeline_id,
  initial_accumulator
) SELECT
  ($1.data->>'crawling_events_pipeline_id')::uuid,
  jsonb_build_object(
    'crawling_event', jsonb_build_object(
      'pipeline_id',   $1.id,
      'crawler_id',    $1.data->>'crawler_id',
      'type',          'sitemap_summary',
      '2xx/3xx_count', COUNT(*) FILTER (WHERE status = 'succeeded' AND NOT( accumulator ? 'status_code' ) ),
      '1xx_count',     COUNT(*) FILTER (WHERE status = 'succeeded' AND (accumulator->>'status_code')::int >= 100 AND (accumulator->>'status_code')::int < 200 ),
      '4xx_count',     COUNT(*) FILTER (WHERE status = 'succeeded' AND (accumulator->>'status_code')::int >= 400 AND (accumulator->>'status_code')::int < 500 ),
      '5xx_count',     COUNT(*) FILTER (WHERE status = 'succeeded' AND (accumulator->>'status_code')::int >= 500 AND (accumulator->>'status_code')::int < 600 )
    )
  )
FROM app.pipe_processes
WHERE
  pipeline_id = $1.id;

SELECT app.pipeline_call(($1.data->>'next_pipeline_id')::uuid);
