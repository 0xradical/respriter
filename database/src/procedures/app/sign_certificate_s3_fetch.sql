CREATE OR REPLACE FUNCTION app.sign_certificate_s3_fetch(
  id         uuid,
  filename   varchar,
  expires_in int
) RETURNS text AS $$
BEGIN
  RETURN app.sign_s3_fetch(
    '$CERTIFICATE_AWS_REGION',
    '$CERTIFICATE_AWS_HOST',
    '$CERTIFICATE_AWS_BUCKET',
    '$CERTIFICATE_AWS_FOLDER',
    id::varchar || '-' || filename,
    '$CERTIFICATE_AWS_ACCESS_KEY_ID',
    '$CERTIFICATE_AWS_SECRET_ACCESS_KEY',
    expires_in,
    '$CERTIFICATE_AWS_IS_HTTPS'::boolean
  );
END;
$$ LANGUAGE plpgsql;
