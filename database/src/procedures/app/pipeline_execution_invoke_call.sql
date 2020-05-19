CREATE FUNCTION app.pipeline_execution_invoke_call(
  uuid
) RETURNS void AS $$
  WITH pipeline_execution AS (
    UPDATE app.pipeline_executions
    SET run_at = NOW()
    WHERE id = $1
    RETURNING *
  )

  INSERT INTO app.pipelines (
    dataset_id,
    pipeline_template_id,
    pipeline_execution_id
  ) SELECT
    pipeline_execution.dataset_id,
    pipeline_execution.pipeline_template_id,
    pipeline_execution.id
  FROM pipeline_execution;

$$ LANGUAGE sql;
