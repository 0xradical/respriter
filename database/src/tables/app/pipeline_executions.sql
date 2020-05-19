CREATE TABLE app.pipeline_executions (
  id                   uuid                DEFAULT public.uuid_generate_v1()     PRIMARY KEY,
  dataset_id           uuid                REFERENCES app.datasets(id)           ON DELETE CASCADE,
  status               app.pipeline_status DEFAULT 'pending',
  pipeline_template_id uuid                REFERENCES app.pipeline_templates(id) ON DELETE CASCADE,
  schedule_interval    interval,
  created_at           timestamptz         DEFAULT NOW()                         NOT NULL,
  updated_at           timestamptz         DEFAULT NOW()                         NOT NULL,
  run_at               timestamptz,
  counter              integer             DEFAULT 1                             NOT NULL,
  name                 varchar                                                   NOT NULL
);
