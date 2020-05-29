CREATE TABLE app.pipeline_templates (
  id                    uuid        DEFAULT public.uuid_generate_v1() PRIMARY KEY,
  dataset_id            uuid        REFERENCES app.datasets(id)       ON DELETE CASCADE,
  created_at            timestamptz DEFAULT NOW()                     NOT NULL,
  updated_at            timestamptz DEFAULT NOW()                     NOT NULL,
  max_retries           integer     DEFAULT 5                         NOT NULL,
  name                  varchar                                       NOT NULL,
  data                  jsonb       DEFAULT '{}',
  pipes                 jsonb       DEFAULT '[]',
  bootstrap_script_type varchar,
  success_script_type   varchar,
  fail_script_type      varchar,
  waiting_script_type   varchar,
  bootstrap_script      text,
  success_script        text,
  fail_script           text,
  waiting_script        text
);
