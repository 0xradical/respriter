CREATE TABLE app.profiles (
  id                  uuid          DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  name                varchar,
  username            app.username,
  _username           varchar       CONSTRAINT username__format CHECK (_username ~* '^\w{5,15}$'),
  username_changed_at timestamptz,
  date_of_birth       date,
  oauth_avatar_url    varchar,
  uploaded_avatar_url varchar,
  instructor          boolean     DEFAULT false,
  long_bio            varchar,
  public              boolean     DEFAULT true,
  website             varchar,
  country             app.iso3166_1_alpha2_code,
  course_ids          uuid[]      DEFAULT '{}'::uuid[],
  short_bio           varchar     CONSTRAINT short_bio__length CHECK (LENGTH(short_bio) <= 60),
  public_profiles     jsonb       DEFAULT '{}'::jsonb,
  social_profiles     jsonb       DEFAULT '{}'::jsonb,
  elearning_profiles  jsonb       DEFAULT '{}'::jsonb,
  teaching_subjects   varchar[]   DEFAULT '{}',
  user_account_id     bigint      REFERENCES app.user_accounts(id) ON DELETE CASCADE,
  interests           text[]      DEFAULT '{}'::text[],
  preferences         jsonb       DEFAULT '{}'::jsonb,
  created_at          timestamptz DEFAULT NOW() NOT NULL,
  updated_at          timestamptz DEFAULT NOW() NOT NULL
);
