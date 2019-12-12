CREATE TABLE app.images (
  id             bigserial   PRIMARY KEY,
  caption        varchar,
  file           varchar,
  pos            integer     DEFAULT 0,
  imageable_type varchar,
  imageable_id   uuid,
  created_at     timestamptz DEFAULT NOW() NOT NULL,
  updated_at     timestamptz DEFAULT NOW() NOT NULL
);
