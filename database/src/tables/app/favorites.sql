CREATE TABLE app.favorites (
  id              bigserial   PRIMARY KEY,
  user_account_id bigint      REFERENCES app.user_accounts(id),
  course_id       uuid        REFERENCES app.courses(id),
  created_at      timestamptz DEFAULT NOW() NOT NULL,
  updated_at      timestamptz DEFAULT NOW() NOT NULL
);
