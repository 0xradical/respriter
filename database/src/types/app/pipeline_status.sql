CREATE TYPE app.pipeline_status AS ENUM (
  'pending',
  'waiting',
  'succeeded',
  'failed'
);
