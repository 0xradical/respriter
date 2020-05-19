CREATE FUNCTION app.pipeline_execution_update_status(
  uuid
) RETURNS void AS $$
  WITH counters AS (
    SELECT
      COUNT(*) FILTER ( WHERE status = 'pending'   ) AS pending_count,
      COUNT(*) FILTER ( WHERE status = 'waiting'   ) AS waiting_count,
      COUNT(*) FILTER ( WHERE status = 'failed'    ) AS failed_count,
      COUNT(*) FILTER ( WHERE status = 'succeeded' ) AS succeeded_count,
      COUNT(*)                                       AS total_count
    FROM app.pipelines
    WHERE pipeline_execution_id = $1
  )

  UPDATE app.pipeline_executions
  SET status = CASE
    WHEN total_count = succeeded_count THEN 'succeeded'
    WHEN failed_count > 0              THEN 'failed'
    WHEN waiting_count > 0             THEN 'waiting'
    ELSE 'pending'
  END::app.pipeline_status
  FROM counters
  WHERE id = $1;
$$ LANGUAGE sql;
