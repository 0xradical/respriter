CREATE TABLE app.courses (
  id                uuid          DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  global_sequence   integer,
  name              varchar,
  description       text,
  slug              varchar,
  url               varchar,
  url_md5           varchar,
  duration_in_hours numeric,
  price             numeric,
  rating            numeric,
  relevance         integer       DEFAULT 0,
  region            varchar,
  audio             text[]        DEFAULT '{}'::text[],
  subtitles         text[]        DEFAULT '{}'::text[],
  published         boolean       DEFAULT true,
  stale             boolean       DEFAULT false,
  category          app.category,
  provider_id       bigint        REFERENCES app.providers(id),
  created_at        timestamptz   DEFAULT NOW() NOT NULL,
  updated_at        timestamptz   DEFAULT NOW() NOT NULL,
  dataset_sequence  integer,
  resource_sequence integer,
  tags              text[]        DEFAULT '{}'::text[],
  video             jsonb,
  source            app.source    DEFAULT 'api'::app.source,
  pace              app.pace,
  certificate       jsonb         DEFAULT '{}'::jsonb,
  pricing_models    jsonb         DEFAULT '[]'::jsonb,
  offered_by        jsonb         DEFAULT '[]'::jsonb,
  syllabus          text,
  effort            integer,
  enrollments_count integer       DEFAULT 0,
  free_content      boolean       DEFAULT false,
  paid_content      boolean       DEFAULT true,
  level             app.level[]   DEFAULT '{}'::app.level[],
  __provider_name__ varchar,
  __source_schema__ jsonb,
  instructors       jsonb         DEFAULT '[]'::jsonb,
  curated_tags      varchar[]     DEFAULT '{}'::varchar[],
  refinement_tags   varchar[]
);
