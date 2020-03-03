WITH current_pipeline_template AS (
  SELECT *
  FROM app.pipeline_templates
  WHERE
    id = $1.pipeline_template_id
),

next_pipeline AS (
  INSERT INTO app.pipelines (
    pipeline_execution_id,
    pipeline_template_id,
    data
  ) SELECT
    $1.pipeline_execution_id,
    (current_pipeline_template.data->>'next_pipeline_template_id')::uuid,
    $1.data - 'next_pipeline_id'
  FROM current_pipeline_template
  RETURNING *
)

UPDATE pipelines
SET data = pipelines.data || jsonb_build_object('next_pipeline_id', next_pipeline.id::varchar)
FROM next_pipeline
WHERE pipelines.id = $1.id;
