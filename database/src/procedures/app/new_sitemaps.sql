CREATE OR REPLACE FUNCTION app.new_sitemaps(
  _sitemaps app.sitemap[]
) RETURNS app.sitemap[] AS $$
  SELECT
    ARRAY_AGG(
      (
        COALESCE(sitemap.id, public.uuid_generate_v4()),
        'unconfirmed',
        sitemap.url,
        sitemap.type
      )::app.sitemap
    )
  FROM unnest(_sitemaps) AS sitemap
  WHERE
    sitemap.url IS NOT NULL
    AND char_length(sitemap.url) > 0
$$ LANGUAGE sql;