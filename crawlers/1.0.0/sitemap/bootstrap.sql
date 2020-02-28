WITH next_pipeline AS (
  INSERT INTO app.pipelines (
    pipeline_execution_id,
    pipeline_template_id,
    data
  ) VALUES (
    $1.pipeline_execution_id,
    ($1.data->>'next_pipeline_template_id')::uuid,
    $1.data - 'next_pipeline_template_id'
  )
  RETURNING *
)

UPDATE pipelines
SET data = pipelines.data || jsonb_build_object('next_pipeline_id', next_pipeline.id::varchar)
FROM next_pipeline
WHERE pipelines.id = $1.id;

INSERT INTO app.pipe_processes (
  pipeline_id,
  initial_accumulator
) SELECT
  $1.id,
  jsonb_build_object('url', sitemap)
FROM jsonb_array_elements_text($1.data->'sitemaps') AS sitemap;

SELECT app.pipeline_call($1.id);
