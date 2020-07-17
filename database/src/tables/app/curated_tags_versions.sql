CREATE TABLE app.curated_tags_versions (
  id                                      uuid                    DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  course_id                               uuid                    REFERENCES app.courses(id),
  curated_tags                            varchar[]               DEFAULT '{}'::varchar[],
  excluded_tags                           varchar[]               DEFAULT '{}'::varchar[],
  created_at                              timestamptz             DEFAULT NOW() NOT NULL,
  updated_at                              timestamptz             DEFAULT NOW() NOT NULL,
  current                                 boolean                 DEFAULT false,
  author                                  varchar
);
