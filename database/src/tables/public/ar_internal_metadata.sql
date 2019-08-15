CREATE TABLE IF NOT EXISTS public.ar_internal_metadata (
  key        varchar     PRIMARY KEY,
  value      varchar,
  created_at timestamptz DEFAULT NOW() NOT NULL,
  updated_at timestamptz DEFAULT NOW() NOT NULL
);