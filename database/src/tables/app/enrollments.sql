CREATE TABLE app.enrollments (
  id                uuid        DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  user_account_id   bigint      REFERENCES app.user_accounts(id),
  course_id         uuid        REFERENCES app.courses(id),
  provider_id       uuid        REFERENCES app.providers(id),
  tracked_url       varchar,
  description       text,
  user_rating       numeric,
  tracked_search_id uuid        REFERENCES app.tracked_searches(id),
  tracking_data     jsonb       DEFAULT '{}'::jsonb,
  tracking_cookies  jsonb       DEFAULT '{}'::jsonb,
  created_at        timestamptz DEFAULT NOW() NOT NULL,
  updated_at        timestamptz DEFAULT NOW() NOT NULL
);
