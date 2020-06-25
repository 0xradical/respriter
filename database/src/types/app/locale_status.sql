CREATE TYPE app.locale_status AS ENUM (
  'empty_audio',
  'manually_overriden',
  'mismatch',
  'multiple_countries',
  'multiple_languages',
  'not_identifiable',
  'ok'
);
