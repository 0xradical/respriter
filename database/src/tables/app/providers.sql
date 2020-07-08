CREATE TABLE app.providers (
  id                             uuid         DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  old_id                         bigserial,
  name                           public.citext,
  name_dirty                     boolean      DEFAULT true NOT NULL,
  name_changed_at                timestamptz  CHECK ((name_dirty) OR (NOT name_dirty AND name_changed_at IS NOT NULL)),
  description                    text,
  slug                           varchar,
  url                            varchar,
  afn_url_template               varchar,
  published                      boolean      DEFAULT false,
  published_at                   timestamptz,
  created_at                     timestamptz  DEFAULT NOW() NOT NULL,
  updated_at                     timestamptz  DEFAULT NOW() NOT NULL,
  encoded_deep_linking           boolean      DEFAULT false,
  featured_on_footer             boolean      DEFAULT false,
  ignore_robots_noindex_rule_for app.locale[] DEFAULT '{}'::app.locale[],
  ignore_robots_noindex_rule     boolean      DEFAULT false
);
