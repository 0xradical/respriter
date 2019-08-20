CREATE TABLE lit.lit_incomming_localizations (
  id                          serial       PRIMARY KEY,
  translated_value            text,
  locale_id                   integer      REFERENCES lit.lit_locales(id),
  localization_key_id         integer      REFERENCES lit.lit_localization_keys(id),
  localization_id             integer      REFERENCES lit.lit_localizations(id),
  locale_str                  varchar,
  localization_key_str        varchar,
  source_id                   integer      REFERENCES lit.lit_sources(id),
  incomming_id                integer,
  created_at                  timestamptz,
  updated_at                  timestamptz,
  localization_key_is_deleted boolean      DEFAULT false NOT NULL
);
