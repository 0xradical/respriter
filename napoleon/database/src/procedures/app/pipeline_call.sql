CREATE FUNCTION app.pipeline_call(
  uuid
) RETURNS void AS $$
  WITH called_pipelines AS (
    SELECT *
    FROM app.pipelines
    WHERE id = $1
  )

  SELECT SUM( app.pipe_process_enqueue_call(pipeline, pipe_process) )
  FROM
    app.pipe_processes AS pipe_process,
    called_pipelines   AS pipeline
  WHERE
    pipeline_id = $1;

  SELECT app.update_pipeline_counters($1);
$$ LANGUAGE sql;

CREATE FUNCTION app.pipeline_call(
  uuid,
  varchar
) RETURNS void AS $$
  WITH called_pipelines AS (
    SELECT *
    FROM app.pipelines
    WHERE id = $1
  )

  SELECT SUM( app.pipe_process_enqueue_call(pipeline, pipe_process) )
  FROM
    app.pipe_processes AS pipe_process,
    called_pipelines   AS pipeline
  WHERE
    pipeline_id         = $1 AND
    pipe_process.status = $2::app.pipe_process_status;

  SELECT app.update_pipeline_counters($1);
$$ LANGUAGE sql;

CREATE FUNCTION app.pipeline_call(
  uuid,
  varchar,
  integer
) RETURNS void AS $$
  WITH called_pipelines AS (
    SELECT *
    FROM app.pipelines
    WHERE id = $1
  )

  SELECT SUM( app.pipe_process_enqueue_call(pipeline, pipe_process) )
  FROM
    app.pipe_processes AS pipe_process,
    called_pipelines   AS pipeline
  WHERE
    pipeline_id         = $1 AND
    pipe_process.status = $2::app.pipe_process_status AND
    process_index       = $3;

  SELECT app.update_pipeline_counters($1);
$$ LANGUAGE sql;
