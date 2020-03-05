CREATE TABLE app.profiles (
  id              uuid DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  name            varchar,
  username        app.username,
  _username       varchar CONSTRAINT username_format CHECK (username ~* '^\w{5,15}$'),
  username_changed_at TIMESTAMPTZ,
  date_of_birth   date,
  oauth_avatar_url varchar,
  uploaded_avatar_url varchar,
  user_account_id bigint    REFERENCES app.user_accounts(id) ON DELETE CASCADE,
  interests       text[]    DEFAULT '{}'::text[],
  preferences     jsonb     DEFAULT '{}'::jsonb,
  created_at      TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at      TIMESTAMPTZ DEFAULT NOW() NOT NULL
);
