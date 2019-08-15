CREATE TABLE api.oauth_accounts (
  id              bigserial   PRIMARY KEY,
  provider        varchar,
  uid             varchar,
  raw_data        jsonb       DEFAULT '{}'::jsonb NOT NULL,
  user_account_id bigint      REFERENCES api.user_accounts(id) ON DELETE CASCADE,
  created_at      timestamptz DEFAULT NOW() NOT NULL,
  updated_at      timestamptz DEFAULT NOW() NOT NULL
);
