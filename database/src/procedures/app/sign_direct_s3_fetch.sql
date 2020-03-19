CREATE OR REPLACE FUNCTION app.sign_direct_s3_fetch(
  id         uuid,
  filename   varchar,
  folder     varchar,
  expires_in int
) RETURNS text AS $$
BEGIN
  RETURN app.sign_s3_fetch(
    '$DIRECT_UPLOAD_AWS_REGION',
    '$DIRECT_UPLOAD_AWS_HOST',
    '$DIRECT_UPLOAD_AWS_BUCKET',
    '$DIRECT_UPLOAD_AWS_ROOT_FOLDER' || '/' || folder,
    id::varchar || '-' || filename,
    '$DIRECT_UPLOAD_AWS_ACCESS_KEY_ID',
    '$DIRECT_UPLOAD_AWS_SECRET_ACCESS_KEY',
    expires_in,
    '$DIRECT_UPLOAD_AWS_IS_HTTPS'::boolean
  );
END;
$$ LANGUAGE plpgsql;