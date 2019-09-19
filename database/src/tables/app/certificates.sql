CREATE TABLE app.certificates (
  id              bigserial   PRIMARY KEY,
  user_account_id bigint      REFERENCES app.user_accounts(id),
  file            varchar     CONSTRAINT valid_file_format CHECK ( lower(file) ~ '.(gif|jpg|jpeg|png|pdf)$' ),
  created_at      timestamptz DEFAULT NOW() NOT NULL,
  updated_at      timestamptz DEFAULT NOW() NOT NULL
);
