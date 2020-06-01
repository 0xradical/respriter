CREATE TYPE app.pipe_process_status AS ENUM (
  'pending',
  'skipped',
  'waiting',
  'failed',
  'succeeded'
);
