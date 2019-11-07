CREATE TABLE app.provider_crawlers (
  id               uuid               DEFAULT    public.uuid_generate_v1() PRIMARY KEY,
  user_agent_token uuid               DEFAULT    public.uuid_generate_v4() NOT NULL,
  provider_id      bigint             REFERENCES app.providers(id),
  published        boolean            DEFAULT    false                     NOT NULL,
  created_at       timestamptz        DEFAULT    NOW()                     NOT NULL,
  updated_at       timestamptz        DEFAULT    NOW()                     NOT NULL,
  status           app.crawler_status DEFAULT    'unverified'              NOT NULL,
  user_account_ids bigint[]           DEFAULT    '{}'                      NOT NULL,
  sitemaps         app.sitemap[]      DEFAULT    '{}'                      NOT NULL
);
