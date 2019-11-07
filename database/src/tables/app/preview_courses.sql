CREATE TABLE app.preview_courses (
  id                  uuid                      DEFAULT    public.uuid_generate_v1()  PRIMARY KEY,
  status              app.preview_course_status DEFAULT    'pending',
  provider_crawler_id uuid                      REFERENCES app.provider_crawlers(id),
  created_at          timestamptz               DEFAULT    NOW()                      NOT NULL,
  updated_at          timestamptz               DEFAULT    NOW()                      NOT NULL,
  data                jsonb
);
