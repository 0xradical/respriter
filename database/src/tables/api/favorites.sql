CREATE TABLE api.favorites (
  id              bigserial   PRIMARY KEY,
  user_account_id bigint      REFERENCES api.user_accounts(id),
  course_id       uuid        REFERENCES api.courses(id),
  created_at      timestamptz DEFAULT NOW() NOT NULL,
  updated_at      timestamptz DEFAULT NOW() NOT NULL
);
