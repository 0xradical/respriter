CREATE TABLE app.providers (
  id                   bigserial    PRIMARY KEY,
  name                 public.citext,
  name_dirty           boolean      DEFAULT true NOT NULL,
  name_changed_at      timestamptz  CHECK ((name_dirty) OR (NOT name_dirty AND name_changed_at IS NOT NULL)),
  description          text,
  slug                 varchar,
  afn_url_template     varchar,
  published            boolean      DEFAULT false,
  published_at         timestamptz,
  created_at           timestamptz  DEFAULT NOW() NOT NULL,
  updated_at           timestamptz  DEFAULT NOW() NOT NULL,
  encoded_deep_linking boolean      DEFAULT false
);
