CREATE TABLE app.resource_schemas (
  id                    uuid        DEFAULT public.uuid_generate_v1() PRIMARY KEY,
  dataset_id            uuid        REFERENCES app.datasets(id)       ON DELETE CASCADE NOT NULL,
  created_at            timestamptz DEFAULT NOW()                                       NOT NULL,
  updated_at            timestamptz DEFAULT NOW()                                       NOT NULL,
  kind                  varchar                                                         NOT NULL,
  schema_version        varchar                                                         NOT NULL,
  specification         jsonb                                                           NOT NULL,
  public_specification  jsonb                                                           NOT NULL
);
