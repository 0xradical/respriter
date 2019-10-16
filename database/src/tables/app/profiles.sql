CREATE TABLE app.profiles (
  id              bigserial PRIMARY KEY,
  name            varchar,
  username        varchar CONSTRAINT username_format CHECK (username ~* '^\w{5,15}$'),
  date_of_birth   date,
  oauth_avatar_url varchar,
  uploaded_avatar_url varchar,
  user_account_id bigint    REFERENCES app.user_accounts(id) ON DELETE CASCADE,
  interests       text[]    DEFAULT '{}'::text[],
  preferences     jsonb     DEFAULT '{}'::jsonb
);
