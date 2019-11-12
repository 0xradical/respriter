CREATE OR REPLACE FUNCTION app.fill_sitemaps(
  _sitemaps app.sitemap[]
) RETURNS app.sitemap[] AS $$
  SELECT
    ARRAY_AGG(
      (
        COALESCE(sitemap.id,     public.uuid_generate_v4()),
        COALESCE(sitemap.status, 'unconfirmed'),
        sitemap.url
      )::app.sitemap
    )
  FROM unnest(_sitemaps) AS sitemap
  WHERE
    sitemap.url IS NOT NULL
    AND char_length(sitemap.url) > 0
$$ LANGUAGE sql;
