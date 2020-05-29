CREATE TABLE app.users (
  id         uuid         DEFAULT public.uuid_generate_v1() PRIMARY KEY,
  dataset_id uuid         REFERENCES app.datasets(id)       ON DELETE CASCADE,
  created_at timestamptz  DEFAULT NOW()                     NOT NULL,
  updated_at timestamptz  DEFAULT NOW()                     NOT NULL,
  password   varchar(60)  DEFAULT ''                        NOT NULL,
  username   varchar      DEFAULT ''                        NOT NULL
);
