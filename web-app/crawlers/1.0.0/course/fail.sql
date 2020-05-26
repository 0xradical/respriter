WITH removed_course_ids AS (
  UPDATE app.resources
  SET content = content || jsonb_build_object('published', false)
  WHERE
    content->>'provider_id'   = $1.data->>'provider_id'
    AND content->>'published' = 'true'
    AND last_execution_id     != $1.pipeline_execution_id
  RETURNING id
),

up_to_date_courses AS (
  SELECT
    COUNT(*)                             AS total_courses,
    COUNT(*) FILTER (WHERE sequence = 1) AS added_courses
  FROM app.resources
  WHERE
    content->>'provider_id'   = $1.data->>'provider_id'
    AND content->>'published' = 'true'
    AND last_execution_id     = $1.pipeline_execution_id
),

removed_courses AS (
  SELECT
    COUNT(*) AS removed_count
  FROM removed_course_ids
  CROSS JOIN up_to_date_courses
),

summary AS (
  SELECT
    removed_courses.removed_count                                       AS removed_count,
    up_to_date_courses.added_courses                                    AS added_count,
    up_to_date_courses.total_courses - up_to_date_courses.added_courses AS updated_count
  FROM removed_courses
  CROSS JOIN up_to_date_courses
)

INSERT INTO app.pipe_processes (
  pipeline_id,
  initial_accumulator
) SELECT
  ($1.data->>'crawling_events_pipeline_id')::uuid,
  jsonb_build_object(
    'crawling_event', jsonb_build_object(
      'pipeline_id',   $1.id,
      'type',          'course_summary',
      'crawler_id',    $1.data->>'crawler_id',
      'removed_count', summary.removed_count,
      'added_count',   summary.added_count,
      'updated_count', summary.updated_count
    )
  )
FROM summary;

INSERT INTO app.pipe_processes (
  pipeline_id,
  initial_accumulator
) SELECT
  ($1.data->>'crawling_events_pipeline_id')::uuid,
  last_accumulator
FROM app.pipe_processes
WHERE
  pipeline_id = $1.id
  AND status = 'skipped'
  AND last_accumulator ? 'crawling_event';

INSERT INTO app.pipe_processes (
  pipeline_id,
  initial_accumulator
) SELECT
  ($1.data->>'crawling_events_pipeline_id')::uuid,
  jsonb_build_object(
    'crawling_event', jsonb_build_object(
      'type',            'course_internal_error',
      'url',             initial_accumulator->>'url',
      'pipeline_id',     $1.id,
      'pipe_process_id', id::varchar,
      'details',         accumulator
    )
  )
FROM app.pipe_processes
WHERE
  pipeline_id = $1.id
  AND status = 'failed';

SELECT app.pipeline_call(($1.data->>'next_pipeline_id')::uuid);
