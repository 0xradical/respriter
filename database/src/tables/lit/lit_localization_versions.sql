CREATE TABLE lit.lit_localization_versions (
  id               serial       PRIMARY KEY,
  translated_value text,
  localization_id  integer      REFERENCES lit.lit_localizations(id),
  created_at       timestamptz,
  updated_at       timestamptz
);
