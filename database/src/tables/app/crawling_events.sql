CREATE TABLE app.crawling_events (
  id                  uuid        DEFAULT    public.uuid_generate_v1() PRIMARY KEY,
  provider_crawler_id uuid        REFERENCES app.provider_crawlers(id) ON DELETE CASCADE,
  created_at          timestamptz DEFAULT    NOW()                     NOT NULL,
  updated_at          timestamptz DEFAULT    NOW()                     NOT NULL,
  sequence            bigint,
  type                varchar                                          NOT NULL,
  data                jsonb
);
