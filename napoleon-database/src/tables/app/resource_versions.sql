CREATE TABLE app.resource_versions (
  id                bigserial            PRIMARY KEY,
  resource_id       uuid                 REFERENCES app.resources(id) ON DELETE CASCADE,
  dataset_sequence  bigint,
  dataset_id        uuid                 REFERENCES app.datasets(id)  ON DELETE CASCADE,
  sequence          bigint,
  status            app.resource_status,
  created_at        timestamptz,
  updated_at        timestamptz,
  unique_id         varchar(40),
  kind              varchar,
  schema_version    varchar,
  content           jsonb,
  relations         jsonb,
  extra             jsonb,
  last_execution_id uuid
);
