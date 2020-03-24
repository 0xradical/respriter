CREATE TYPE app.provider_logo AS (
  id uuid,
  provider_id bigint,
  file varchar,
  user_account_id bigint,
  created_at timestamptz,
  updated_at timestamptz,
  fetch_url text,
  upload_url text,
  file_content_type varchar
);
