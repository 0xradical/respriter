CREATE TABLE lit.lit_sources (
  id              serial        PRIMARY KEY,
  identifier      varchar,
  url             varchar,
  api_key         varchar,
  last_updated_at timestamptz,
  created_at      timestamptz,
  updated_at      timestamptz,
  sync_complete   boolean
);
