CREATE TABLE api.profiles (
  id              bigserial PRIMARY KEY,
  name            varchar,
  date_of_birth   date,
  avatar          varchar,
  user_account_id bigint    REFERENCES api.user_accounts(id) ON DELETE CASCADE,
  interests       text[]    DEFAULT '{}'::text[],
  preferences     jsonb     DEFAULT '{}'::jsonb
);
