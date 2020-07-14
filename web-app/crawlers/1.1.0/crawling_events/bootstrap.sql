WITH RECURSIVE previous_pipelines AS (
  SELECT *
  FROM app.pipelines
  WHERE
   pipelines.data->>'next_pipeline_id' = ($1.id)::varchar
UNION
  SELECT pipelines.*
  FROM app.pipelines
  INNER JOIN previous_pipelines ON
    (pipelines.data->>'next_pipeline_id')::uuid = previous_pipelines.id
)

UPDATE pipelines
SET data = pipelines.data || jsonb_build_object('crawling_events_pipeline_id', ($1.id)::varchar)
FROM previous_pipelines
WHERE pipelines.id = previous_pipelines.id;
