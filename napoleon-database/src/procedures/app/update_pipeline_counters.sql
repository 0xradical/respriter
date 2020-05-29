CREATE FUNCTION app.update_pipeline_counters(
  uuid
) RETURNS void AS $$
  UPDATE app.pipelines
  SET total_count     = pipe_processes_query.total_count,
      succeeded_count = pipe_processes_query.succeeded_count + pipe_processes_query.skipped_count,
      failed_count    = pipe_processes_query.failed_count,
      waiting_count   = pipe_processes_query.waiting_count
  FROM (
    SELECT
      COUNT(*)                                                   AS total_count,
      COUNT(CASE WHEN status = 'succeeded' THEN 1 ELSE NULL END) AS succeeded_count,
      COUNT(CASE WHEN status = 'skipped'   THEN 1 ELSE NULL END) AS skipped_count,
      COUNT(CASE WHEN status = 'failed'    THEN 1 ELSE NULL END) AS failed_count,
      COUNT(CASE WHEN status = 'waiting'   THEN 1 ELSE NULL END) AS waiting_count
    FROM app.pipe_processes
    WHERE
      pipeline_id = $1
  ) AS pipe_processes_query
  WHERE app.pipelines.id = $1;
$$ SECURITY DEFINER LANGUAGE sql;
