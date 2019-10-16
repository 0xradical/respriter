CREATE TABLE app.contacts (
  id         bigserial   PRIMARY KEY,
  name       varchar,
  email      varchar,
  subject    varchar,
  message    text,
  created_at timestamptz DEFAULT NOW() NOT NULL,
  updated_at timestamptz DEFAULT NOW() NOT NULL
);
