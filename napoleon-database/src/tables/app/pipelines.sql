CREATE TABLE app.pipelines (
  id                    uuid                DEFAULT public.uuid_generate_v1()      PRIMARY KEY,
  dataset_id            uuid                REFERENCES app.datasets(id)            ON DELETE CASCADE,
  pipeline_execution_id uuid                REFERENCES app.pipeline_executions(id) ON DELETE CASCADE,
  pipeline_template_id  uuid                REFERENCES app.pipeline_templates(id)  ON DELETE SET NULL,
  status                app.pipeline_status DEFAULT 'pending',
  total_count           integer             DEFAULT 0,
  waiting_count         integer             DEFAULT 0,
  failed_count          integer             DEFAULT 0,
  succeeded_count       integer             DEFAULT 0,
  created_at            timestamptz         DEFAULT NOW()                          NOT NULL,
  updated_at            timestamptz         DEFAULT NOW()                          NOT NULL,
  max_retries           integer,
  name                  varchar                                                    NOT NULL,
  data                  jsonb,
  pipes                 jsonb,
  bootstrap_script_type varchar,
  success_script_type   varchar,
  fail_script_type      varchar,
  waiting_script_type   varchar,
  bootstrap_script      text,
  success_script        text,
  fail_script           text,
  waiting_script        text
);