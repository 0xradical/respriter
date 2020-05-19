CREATE FUNCTION app.pipe_process_enqueue_call(
  _pipeline     app.pipelines,
  _pipe_process app.pipe_processes
) RETURNS integer AS $$
  INSERT INTO public.que_jobs (
    job_class,
    args
  ) VALUES (
    'PipeProcess::CallJob',
    jsonb_build_array(
      _pipe_process.id::varchar,
      jsonb_build_object(
        'pipeline_id',           _pipeline.id,
        'pipeline_execution_id', _pipeline.pipeline_execution_id
      )
    )
  )
  RETURNING 1;
$$ LANGUAGE sql;

CREATE FUNCTION app.pipe_process_enqueue_call(
  _pipe_process app.pipe_processes
) RETURNS integer AS $$
  SELECT
    SUM( app.pipe_process_enqueue_call(pipeline, _pipe_process) )::integer
  FROM app.pipelines AS pipeline
  WHERE
    id = _pipe_process.pipeline_id;
$$ LANGUAGE sql;
