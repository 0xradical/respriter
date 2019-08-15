CREATE TABLE api.landing_pages (
  id            bigserial   PRIMARY KEY,
  slug          public.citext,
  template      varchar,
  meta_html     text,
  html          jsonb       DEFAULT '{}'::jsonb,
  body_html     text,
  created_at    timestamptz DEFAULT NOW() NOT NULL,
  updated_at    timestamptz DEFAULT NOW() NOT NULL,
  data          jsonb       DEFAULT '{}'::jsonb,
  erb_template  text,
  layout        varchar
);
