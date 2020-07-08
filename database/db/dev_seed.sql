BEGIN;

CREATE TEMP TABLE user_and_provider (
  id                  bigint PRIMARY KEY,
  provider_id         uuid,
  username            varchar,
  provider_crawler_id uuid
);

-- URLs Provider

WITH new_user AS (
  INSERT INTO app.user_accounts ( email, encrypted_password, confirmed_at )
  VALUES ( 'user@urls.provider.clspt', 'abc123', NOW() )
  RETURNING *
),
new_provider AS (
  INSERT INTO app.providers ( name, description, slug, published )
  VALUES ( 'URLs Provider', 'Sitemapless Provider', 'sitemapless-provider', TRUE )
  RETURNING *
),
new_provider_crawler AS (
  INSERT INTO app.provider_crawlers ( provider_id, published )
  SELECT new_provider.id, TRUE
  FROM new_provider
  RETURNING *
),
new_crawler_domain AS (
  INSERT INTO app.crawler_domains ( provider_crawler_id, authority_confirmation_status, domain )
  SELECT new_provider_crawler.id, 'confirmed', 'urls.provider.clspt'
  FROM new_provider_crawler
  RETURNING *
)
INSERT INTO user_and_provider ( id, provider_id, username, provider_crawler_id )
SELECT new_user.id, new_provider.id, 'sitemapless', new_provider_crawler.id
FROM new_user
CROSS JOIN new_provider
CROSS JOIN new_provider_crawler;

UPDATE app.provider_crawlers SET
  user_account_ids = ARRAY[other.id],
  urls = ARRAY[
    'http://urls.provider.clspt/free_01.html',
    'http://urls.provider.clspt/free_02.html',
    'http://urls.provider.clspt/multi_price_01.html',
    'http://urls.provider.clspt/multi_price_02.html',
    'http://urls.provider.clspt/single_01.html',
    'http://urls.provider.clspt/single_02.html',
    'http://urls.provider.clspt/subscription_01.html',
    'http://urls.provider.clspt/subscription_02.html'
  ]
FROM user_and_provider AS other
WHERE EXISTS ( SELECT 1 FROM app.providers WHERE slug = 'sitemapless-provider' AND providers.id = provider_crawlers.provider_id )
  AND provider_crawlers.provider_id = other.provider_id;

-- Sitemaps Provider

WITH new_user AS (
  INSERT INTO app.user_accounts ( email, encrypted_password, confirmed_at )
  VALUES ( 'user@sitemaps.provider.clspt', 'abc123', NOW() )
  RETURNING *
),
new_provider AS (
  INSERT INTO app.providers ( name, description, slug, published )
  VALUES ( 'Sitemaps Provider', 'Sitemap Provider', 'sitemap-provider', TRUE )
  RETURNING *
),
new_provider_crawler AS (
  INSERT INTO app.provider_crawlers ( provider_id, published )
  SELECT new_provider.id, TRUE
  FROM new_provider
  RETURNING *
),
new_crawler_domain AS (
  INSERT INTO app.crawler_domains ( provider_crawler_id, authority_confirmation_status, domain )
  SELECT new_provider_crawler.id, 'confirmed', 'sitemaps.provider.clspt'
  FROM new_provider_crawler
  RETURNING *
)
INSERT INTO user_and_provider ( id, provider_id, username, provider_crawler_id )
SELECT new_user.id, new_provider.id, 'with_sitemap', new_provider_crawler.id
FROM new_user
CROSS JOIN new_provider
CROSS JOIN new_provider_crawler;

UPDATE app.provider_crawlers SET
  user_account_ids = ARRAY[other.id],
  sitemaps         = '{"(\"9d620804-535f-11ea-8c87-0242ac160009\",\"verified\",\"http://sitemaps.provider.clspt/sitemap.xml\",\"sitemap\")"}'
FROM user_and_provider AS other
WHERE EXISTS ( SELECT 1 FROM app.providers WHERE slug = 'sitemap-provider' AND providers.id = provider_crawlers.provider_id )
  AND provider_crawlers.provider_id = other.provider_id;

-- Both Provider

WITH new_user AS (
  INSERT INTO app.user_accounts ( email, encrypted_password, confirmed_at )
  VALUES ( 'user@both.provider.clspt', 'abc123', NOW() )
  RETURNING *
),
new_provider AS (
  INSERT INTO app.providers ( name, description, slug, published )
  VALUES ( 'Both Provider', 'Provider with URLs and Sitemap', 'both-provider', TRUE )
  RETURNING *
),
new_provider_crawler AS (
  INSERT INTO app.provider_crawlers ( provider_id, published )
  SELECT new_provider.id, TRUE
  FROM new_provider
  RETURNING *
),
new_crawler_domain AS (
  INSERT INTO app.crawler_domains ( provider_crawler_id, authority_confirmation_status, domain )
  SELECT new_provider_crawler.id, 'confirmed', 'both.provider.clspt'
  FROM new_provider_crawler
  RETURNING *
)
INSERT INTO user_and_provider ( id, provider_id, username, provider_crawler_id )
SELECT new_user.id, new_provider.id, 'with_both', new_provider_crawler.id
FROM new_user
CROSS JOIN new_provider
CROSS JOIN new_provider_crawler;

UPDATE app.provider_crawlers SET
  user_account_ids = ARRAY[other.id],
  sitemaps         = '{"(\"408026d9-f535-ae11-78c8-900061ca2420\",\"verified\",\"http://both.provider.clspt/sitemap.xml\",\"sitemap\")"}',
  urls = ARRAY[
    'http://both.provider.clspt/free_01.html',
    'http://both.provider.clspt/free_02.html',
    'http://both.provider.clspt/multi_price_01.html',
    'http://both.provider.clspt/multi_price_02.html'
  ]
FROM user_and_provider AS other
WHERE EXISTS ( SELECT 1 FROM app.providers WHERE slug = 'both-provider' AND providers.id = provider_crawlers.provider_id )
  AND provider_crawlers.provider_id = other.provider_id;

INSERT INTO app.profiles (user_account_id, name, username, username_changed_at)
SELECT
  user_and_provider.id,
  providers.name,
  user_and_provider.username,
  NOW()
FROM user_and_provider
INNER JOIN app.providers ON
  providers.id = user_and_provider.provider_id;

DROP TABLE user_and_provider;

COMMIT;
