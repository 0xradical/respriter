CREATE OR REPLACE FUNCTION app.merge_sitemaps(
  _old_sitemaps app.sitemap[],
  _new_sitemaps app.sitemap[]
) RETURNS app.sitemap[] AS $$
  SELECT
    ARRAY_AGG(
      COALESCE(old_sitemap, new_sitemap)
    )
  FROM      unnest(_new_sitemaps) AS new_sitemap
  LEFT JOIN unnest(_old_sitemaps) AS old_sitemap ON
    new_sitemap.id = old_sitemap.id
$$ LANGUAGE sql;