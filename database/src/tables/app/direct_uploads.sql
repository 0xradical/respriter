CREATE TABLE app.direct_uploads (
  id              uuid DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  user_account_id bigint      REFERENCES app.user_accounts(id),
  file            varchar     CONSTRAINT valid_file_format CHECK ( LOWER(file) ~ '.(gif|jpg|jpeg|png|pdf|svg)$' ),
  created_at      timestamptz DEFAULT NOW() NOT NULL,
  updated_at      timestamptz DEFAULT NOW() NOT NULL
);
