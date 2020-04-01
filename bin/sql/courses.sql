COPY (
  SELECT
    courses.*
  FROM subsets.courses
  LEFT JOIN app.provider_crawlers ON
    provider_crawlers.provider_id = courses.provider_id
  WHERE provider_crawlers.id IS NULL
) TO STDOUT WITH CSV HEADER DELIMITER ',';
