CREATE TABLE api.tracked_searches (
  id            uuid        DEFAULT public.uuid_generate_v1() PRIMARY KEY,
  version       varchar,
  action        varchar,
  request       jsonb,
  results       jsonb,
  tracked_data  jsonb,
  created_at    timestamptz DEFAULT NOW() NOT NULL,
  updated_at    timestamptz DEFAULT NOW() NOT NULL
);
