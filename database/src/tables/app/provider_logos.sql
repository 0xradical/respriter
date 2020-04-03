CREATE TABLE app.provider_logos (
  id               uuid DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  direct_upload_id uuid REFERENCES app.direct_uploads(id) NOT NULL,
  provider_id      bigint REFERENCES app.providers(id) NOT NULL
);
