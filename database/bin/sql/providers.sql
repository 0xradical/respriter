COPY (
  SELECT providers.*
  FROM app.providers
  LEFT JOIN app.provider_crawlers ON
    provider_crawlers.provider_id = providers.id
  WHERE provider_crawlers.id IS NULL
) TO STDOUT WITH CSV HEADER DELIMITER ',';
