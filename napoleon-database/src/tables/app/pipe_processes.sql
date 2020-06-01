CREATE TABLE app.pipe_processes (
  id                  uuid                    DEFAULT public.uuid_generate_v1() PRIMARY KEY,
  pipeline_id         uuid                    REFERENCES app.pipelines(id)      ON DELETE CASCADE,
  status              app.pipe_process_status DEFAULT 'pending'                 NOT NULL,
  process_index       integer                 DEFAULT 0                         NOT NULL,
  created_at          timestamptz             DEFAULT NOW()                     NOT NULL,
  updated_at          timestamptz             DEFAULT NOW()                     NOT NULL,
  initial_accumulator jsonb,
  accumulator         jsonb,
  last_accumulator    jsonb,
  data                jsonb,
  last_data           jsonb,
  error_backtrace     varchar[],
  retried_in          integer[]
);
