CREATE TABLE app.preview_course_images (
  id             uuid   DEFAULT    public.uuid_generate_v1() PRIMARY KEY,
  kind           varchar,
  file           varchar,
  preview_course_id uuid REFERENCES app.preview_courses(id),
  created_at     timestamptz DEFAULT NOW() NOT NULL,
  updated_at     timestamptz DEFAULT NOW() NOT NULL
);