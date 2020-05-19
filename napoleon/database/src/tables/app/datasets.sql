CREATE TABLE app.datasets (
  id         uuid        DEFAULT public.uuid_generate_v1() PRIMARY KEY,
  sequence   bigint      DEFAULT 0,
  created_at timestamptz DEFAULT NOW()                     NOT NULL,
  updated_at timestamptz DEFAULT NOW()                     NOT NULL,
  name       varchar
);
