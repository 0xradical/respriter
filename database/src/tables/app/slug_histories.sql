CREATE TABLE app.slug_histories (
  id         uuid        DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  course_id  uuid        REFERENCES app.courses(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT NOW() NOT NULL,
  updated_at timestamptz DEFAULT NOW() NOT NULL,
  slug       varchar                   NOT NULL
);
