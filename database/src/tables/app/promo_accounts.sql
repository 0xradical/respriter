CREATE TABLE app.promo_accounts (
  id              bigserial PRIMARY KEY,
  user_account_id bigint    REFERENCES app.user_accounts(id) ON DELETE CASCADE,
  data            jsonb     DEFAULT '{}'::jsonb,
  created_at      timestamptz  DEFAULT NOW()       NOT NULL,
  updated_at      timestamptz  DEFAULT NOW()       NOT NULL
);
