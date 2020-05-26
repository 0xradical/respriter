CREATE TABLE app.subscriptions (
  id              uuid        DEFAULT public.uuid_generate_v4() UNIQUE NOT NULL PRIMARY KEY,
  digest          boolean     DEFAULT true NOT NULL,
  newsletter      boolean     DEFAULT true NOT NULL,
  promotions      boolean     DEFAULT true NOT NULL,
  recommendations boolean     DEFAULT true NOT NULL,
  reports         boolean     DEFAULT true NOT NULL,
  unsubscribe_reasons jsonb   DEFAULT '{}'::jsonb,
  unsubscribed_at timestamptz,
  profile_id      uuid        REFERENCES app.profiles(id),
  created_at      timestamptz  DEFAULT NOW() NOT NULL
);