CREATE TABLE app.promo_accounts (
  id              bigserial PRIMARY KEY,
  user_account_id bigint REFERENCES app.user_accounts(id) ON DELETE CASCADE CONSTRAINT cntr_promo_accounts_user_account_id UNIQUE,
  price           numeric(6,2) NOT NULL,
  purchase_date   date  NOT NULL,
  order_id        varchar,
  paypal_account  varchar,
  created_at      timestamptz  DEFAULT NOW() NOT NULL,
  updated_at      timestamptz  DEFAULT NOW() NOT NULL
);