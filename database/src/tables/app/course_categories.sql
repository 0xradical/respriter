CREATE TABLE app.course_categories (
  id                uuid        DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  parent_id         uuid        REFERENCES app.course_categories(id),
  key               varchar,
  created_at        timestamptz DEFAULT NOW() NOT NULL,
  updated_at        timestamptz DEFAULT NOW() NOT NULL
);
