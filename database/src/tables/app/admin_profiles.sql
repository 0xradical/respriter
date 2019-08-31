CREATE TABLE app.admin_profiles (
  id                bigserial   PRIMARY KEY,
  name              varchar,
  bio               text,
  preferences       jsonb,
  admin_account_id  bigint      REFERENCES app.admin_accounts(id) ON DELETE CASCADE,
  created_at        timestamptz DEFAULT NOW() NOT NULL,
  updated_at        timestamptz DEFAULT NOW() NOT NULL
);
