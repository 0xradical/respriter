CREATE FUNCTION util.pipe_process_retry_call(
  _id             uuid,
  _process_index  integer DEFAULT 0,
  _accumulator    jsonb   DEFAULT NULL,
  _data           jsonb   DEFAULT NULL
) RETURNS bigint AS $$
  WITH updated_processes AS (
    UPDATE app.pipe_processes
    SET
      status           = 'pending',
      process_index    = _process_index,
      data             = _data,
      accumulator      = _accumulator,
      last_data        = NULL,
      last_accumulator = NULL,
      error_backtrace  = NULL
    WHERE id = _id
    RETURNING *
  )

  SELECT SUM( app.pipe_process_enqueue_call(pipe_process) )
  FROM updated_processes AS pipe_process;

$$ LANGUAGE sql;
