CREATE FUNCTION app.normalize_languages(languages text[]) RETURNS text[] AS $$
DECLARE
  upcased_languages text[];
BEGIN
  WITH

  subtitles AS (
    SELECT DISTINCT unnest(languages) AS subtitle
  ),

  subtitle_arrays AS (
    SELECT regexp_split_to_array(subtitle, '-') AS subtitle_array
    FROM subtitles
  )

  SELECT DISTINCT
    ARRAY_AGG(
      CASE WHEN array_length(subtitle_array, 1) = 2
      THEN subtitle_array[1] || '-' || upper(subtitle_array[2])
      ELSE subtitle_array[1]
      END
    )
  FROM subtitle_arrays
  INTO upcased_languages;

  RETURN upcased_languages;
END;
$$ LANGUAGE plpgsql;
