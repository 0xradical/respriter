CREATE TABLE app.profiles (
  id              bigserial PRIMARY KEY,
  name            varchar,
  username        varchar,
  date_of_birth   date,
  avatar          varchar,
  user_account_id bigint    REFERENCES app.user_accounts(id) ON DELETE CASCADE,
  interests       text[]    DEFAULT '{}'::text[],
  preferences     jsonb     DEFAULT '{}'::jsonb
);
