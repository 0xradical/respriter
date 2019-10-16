CREATE TABLE app.posts (
  id                  bigserial       PRIMARY KEY,
  slug                varchar,
  title               varchar,
  body                text,
  tags                varchar[]       DEFAULT '{}'::varchar[],
  meta                jsonb           DEFAULT '"{\"title\": \"\", \"description\": \"\"}"'::jsonb,
  locale              app.iso639_code DEFAULT 'en'::app.iso639_code,
  status              app.post_status DEFAULT 'draft'::app.post_status,
  content_fingerprint varchar,
  published_at        timestamptz,
  content_changed_at  timestamptz,
  admin_account_id    bigint          REFERENCES app.admin_accounts(id),
  created_at          timestamptz     DEFAULT NOW() NOT NULL,
  updated_at          timestamptz     DEFAULT NOW() NOT NULL,
  original_post_id    bigint          REFERENCES app.posts(id),
  use_cover_image     boolean         DEFAULT false
);
