CREATE TABLE api.providers (
  id                   bigserial    PRIMARY KEY,
  name                 public.citext,
  description          text,
  slug                 varchar,
  afn_url_template     varchar,
  published            boolean      DEFAULT false,
  published_at         timestamptz,
  created_at           timestamptz  DEFAULT NOW() NOT NULL,
  updated_at           timestamptz  DEFAULT NOW() NOT NULL,
  encoded_deep_linking boolean      DEFAULT false
);
