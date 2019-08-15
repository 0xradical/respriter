CREATE TABLE lit.lit_localizations (
  id                  serial       PRIMARY KEY,
  locale_id           integer      REFERENCES lit.lit_locales(id),
  localization_key_id integer      REFERENCES lit.lit_localization_keys(id),
  default_value       text,
  translated_value    text,
  is_changed          boolean      DEFAULT false,
  created_at          timestamptz,
  updated_at          timestamptz
);
