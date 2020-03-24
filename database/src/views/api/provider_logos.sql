CREATE OR REPLACE VIEW api.provider_logos AS
  SELECT
    app.provider_logos.id as id,
    app.provider_logos.provider_id as provider_id,
    app.direct_uploads.file as file,
    app.direct_uploads.user_account_id as user_account_id,
    app.direct_uploads.created_at as created_at,
    app.direct_uploads.updated_at as updated_at,
    app.sign_direct_s3_fetch(app.direct_uploads.id, app.direct_uploads.file, 'provider_logos/' || app.provider_logos.provider_id::varchar, 3600)  AS fetch_url,
    app.sign_direct_s3_upload(app.direct_uploads.id, app.direct_uploads.file, 'provider_logos/' || app.provider_logos.provider_id::varchar, 3600) AS upload_url,
    app.content_type_by_extension(app.direct_uploads.file)                              AS file_content_type
  FROM app.provider_logos
  INNER JOIN app.direct_uploads ON app.direct_uploads.id = app.provider_logos.direct_upload_id
  WHERE
    current_user = 'admin' OR (
      current_user = 'user' AND
      current_setting('request.jwt.claim.sub', true)::bigint = app.direct_uploads.user_account_id
    );

CREATE OR REPLACE FUNCTION triggers.api_provider_logos_view_instead() RETURNS trigger AS $$
DECLARE
  current_user_id bigint;
  direct_upload app.direct_uploads;
  provider_logo app.provider_logo;
  filename varchar;
  file_content_type varchar;
  fetch_url text;
  upload_url text;
BEGIN
  current_user_id   := current_setting('request.jwt.claim.sub', true)::bigint;
  filename          := NEW.file;

  IF (TG_OP = 'INSERT') THEN
    INSERT INTO app.direct_uploads (
      id,
      user_account_id,
      file
    ) VALUES (
      NEW.id,
      current_user_id,
      filename
    ) ON CONFLICT (id) DO
      UPDATE set file = filename
      RETURNING * INTO direct_upload;
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE app.direct_uploads
    SET
      user_account_id   = current_user_id,
      file              = filename
    WHERE
      id = OLD.id
    RETURNING * INTO direct_upload;
  END IF;

  file_content_type := app.content_type_by_extension(filename);
  fetch_url         := app.sign_direct_s3_fetch(direct_upload.id, filename, 'provider_logos/' || NEW.provider_id::varchar, 3600);
  upload_url        := app.sign_direct_s3_upload(direct_upload.id, filename, 'provider_logos/' || NEW.provider_id::varchar, 3600);

  INSERT INTO app.provider_logos (
    direct_upload_id,
    provider_id
  ) VALUES (
    direct_upload.id,
    NEW.provider_id
  ) ON CONFLICT (provider_id) DO
    UPDATE set direct_upload_id = direct_upload.id;

  SELECT app.provider_logos.id INTO provider_logo FROM app.provider_logos WHERE app.provider_logos.provider_id = NEW.provider_id;
  provider_logo.provider_id := NEW.provider_id;
  provider_logo.file := filename;
  provider_logo.user_account_id := current_user_id;
  provider_logo.created_at := direct_upload.created_at;
  provider_logo.updated_at := direct_upload.updated_at;
  provider_logo.fetch_url := fetch_url;
  provider_logo.upload_url := upload_url;
  provider_logo.file_content_type := file_content_type;

  RETURN provider_logo;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_provider_logos_view_instead
  INSTEAD OF INSERT OR UPDATE
  ON api.provider_logos
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_provider_logos_view_instead();
