CREATE TABLE app.course_reviews (
  id                uuid DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  user_account_id   bigint REFERENCES app.user_accounts(id) ON DELETE CASCADE,
  tracked_action_id uuid REFERENCES app.tracked_actions(id) ON DELETE CASCADE,
  rating            numeric(1,0),
  completed         boolean,
  feedback          varchar,
  state             varchar NOT NULL DEFAULT 'pending',
  created_at        timestamptz  DEFAULT NOW() NOT NULL,
  updated_at        timestamptz  DEFAULT NOW() NOT NULL,
  CONSTRAINT rating__greater_than CHECK (rating >= 1),
  CONSTRAINT rating__less_than CHECK (rating <= 5),
  CONSTRAINT state__inclusion CHECK (state IN ('pending','accessed','submitted'))
);