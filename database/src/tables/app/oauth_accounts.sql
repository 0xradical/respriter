CREATE TABLE app.oauth_accounts (
  id              bigserial   PRIMARY KEY,
  provider        varchar,
  uid             varchar,
  raw_data        jsonb       DEFAULT '{}'::jsonb NOT NULL,
  user_account_id bigint      REFERENCES app.user_accounts(id) ON DELETE CASCADE,
  created_at      timestamptz DEFAULT NOW() NOT NULL,
  updated_at      timestamptz DEFAULT NOW() NOT NULL
);
