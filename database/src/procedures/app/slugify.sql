CREATE OR REPLACE FUNCTION app.slugify(value varchar)
RETURNS TEXT AS $$
  WITH unaccented AS (
    SELECT unaccent(value) AS value
  ),

  lowercase AS (
    SELECT lower(value) AS value
    FROM unaccented
  ),

  hyphenated AS (
    SELECT regexp_replace(value, '[^a-z0-9\\-_]+', '-', 'gi') AS value
    FROM lowercase
  ),

  trimmed AS (
    SELECT regexp_replace(regexp_replace(value, '\\-+$', ''), '^\\-', '') AS value
    FROM hyphenated
  )

  SELECT value FROM trimmed;
$$ LANGUAGE SQL STRICT IMMUTABLE;
