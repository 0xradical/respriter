CREATE TABLE app.promo_accounts (
  id              uuid DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  user_account_id bigint REFERENCES app.user_accounts(id) ON DELETE CASCADE CONSTRAINT cntr_promo_accounts_user_account_id UNIQUE,
  certificate_id  uuid REFERENCES app.certificates(id) ON DELETE CASCADE,
  price           numeric(6,2) NOT NULL,
  purchase_date   date  NOT NULL CONSTRAINT purchase_date__less_than CHECK (purchase_date < NOW()),
  order_id        varchar NOT NULL,
  paypal_account  varchar NOT NULL,
  state           varchar NOT NULL DEFAULT 'initial',
  created_at      timestamptz  DEFAULT NOW() NOT NULL,
  updated_at      timestamptz  DEFAULT NOW() NOT NULL,
  CONSTRAINT price__greater_than CHECK (price >= 0),
  CONSTRAINT price__less_than CHECK (price <= 5000),
  CONSTRAINT paypal_account__email CHECK (paypal_account ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'),
  CONSTRAINT state__inclusion CHECK (state IN ('initial','pending','locked','rejected','approved'))
);