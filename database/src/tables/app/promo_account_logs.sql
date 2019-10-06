CREATE TABLE app.promo_account_logs (
  id uuid DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  promo_account_id uuid REFERENCES app.promo_accounts(id) ON DELETE CASCADE,
  old jsonb DEFAULT '{}'::jsonb,
  new jsonb DEFAULT '{}'::jsonb,
  role varchar NOT NULL
);