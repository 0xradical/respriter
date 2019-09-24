CREATE TABLE app.promo_account_certificates (
  id               bigserial PRIMARY KEY,
  promo_account_id bigint REFERENCES app.promo_accounts(id) ON DELETE CASCADE CONSTRAINT cntr_promo_account_certificates_promo_account_id UNIQUE,
  certificate_id   bigint REFERENCES app.certificates(id) ON DELETE CASCADE,
  state            varchar DEFAULT 'initial',
  created_at       timestamptz  DEFAULT NOW() NOT NULL,
  updated_at       timestamptz  DEFAULT NOW() NOT NULL
);
