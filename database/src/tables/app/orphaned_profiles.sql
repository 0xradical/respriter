CREATE TABLE app.orphaned_profiles (
  id                          uuid DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  user_account_id             bigint REFERENCES app.user_accounts(id) ON DELETE CASCADE,
  name                        varchar(75) NOT NULL,
  country                     varchar(3),
  short_bio                   varchar(200),
  long_bio                    text,
  email                       varchar(320),
  website                     varchar,
  avatar_url                  varchar,
  public_profiles             jsonb DEFAULT '{}'::jsonb,
  languages                   varchar[] DEFAULT '{}',
  course_ids                  uuid[] DEFAULT '{}',
  state                       varchar(20) DEFAULT 'disabled',
  slug                        varchar,
  claimable_emails            varchar[] DEFAULT '{}',
  claimable_public_profiles   jsonb DEFAULT '{}'::jsonb,
  claim_code                  varchar(7),
  created_at                  timestamptz DEFAULT NOW() NOT NULL,
  updated_at                  timestamptz DEFAULT NOW() NOT NULL
  CONSTRAINT                  state__inclusion CHECK (state IN ('disabled','enabled'))
);
