CREATE TABLE app.resources (
  id                uuid                DEFAULT public.uuid_generate_v1() PRIMARY KEY,
  dataset_id        uuid                REFERENCES app.datasets(id)       ON DELETE CASCADE NOT NULL,
  sequence          bigint              DEFAULT 1                                           NOT NULL,
  status            app.resource_status DEFAULT 'active'                                    NOT NULL,
  created_at        timestamptz         DEFAULT NOW()                                       NOT NULL,
  updated_at        timestamptz         DEFAULT NOW()                                       NOT NULL,
  unique_id         varchar(40)                                                             NOT NULL,
  kind              varchar                                                                 NOT NULL,
  schema_version    varchar,
  content           jsonb               DEFAULT '{}',
  relations         jsonb               DEFAULT '{}',
  extra             jsonb,
  last_execution_id uuid
);
