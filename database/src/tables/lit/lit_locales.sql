CREATE TABLE lit.lit_locales (
  id          serial       PRIMARY KEY,
  locale      varchar,
  created_at  timestamptz,
  updated_at  timestamptz,
  is_hidden   boolean      DEFAULT false
);
