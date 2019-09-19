CREATE OR REPLACE VIEW api.certificates AS
  SELECT
    id,
    user_account_id,
    file,
    created_at,
    updated_at,
    app.sign_certificate_s3_fetch(id, file, 3600) AS fetch_url,
    app.sign_certificate_s3_upload(id, file, 3600) AS upload_url
  FROM app.certificates
  WHERE
    current_user = 'admin' OR (
      current_user = 'user' AND
      current_setting('request.jwt.claim.sub', true)::bigint = user_account_id
    );

CREATE OR REPLACE FUNCTION triggers.api_certificates_view_instead() RETURNS trigger AS $$
DECLARE
  certificate record;
BEGIN
  IF (TG_OP = 'INSERT') THEN
    IF if_admin(TRUE) OR if_user_by_id(NEW.user_account_id, TRUE) THEN
      INSERT INTO app.certificates (
        user_account_id,
        file
      ) VALUES (
        NEW.user_account_id,
        NEW.file
      ) RETURNING * INTO certificate;
    ELSE
      RAISE EXCEPTION 'Unauthorized Request';
    END IF;
  ELSIF (TG_OP = 'UPDATE') THEN
    IF if_admin(TRUE) OR ( if_user_by_id(OLD.user_account_id, TRUE) AND if_user_by_id(NEW.user_account_id, TRUE) ) THEN
      UPDATE app.certificates
      SET
        user_account_id = NEW.user_account_id,
        file            = NEW.file
      WHERE
        id = OLD.id
      RETURNING * INTO certificate;
    ELSE
      RAISE EXCEPTION 'Unauthorized Request';
    END IF;
  END IF;

  NEW.id         = certificate.id;
  NEW.created_at = certificate.created_at;
  NEW.updated_at = certificate.updated_at;
  NEW.fetch_url  = app.sign_certificate_s3_fetch(NEW.id, NEW.file, 3600);
  NEW.upload_url = app.sign_certificate_s3_upload(NEW.id, NEW.file, 3600);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_certificates_view_instead
  INSTEAD OF INSERT OR UPDATE
  ON api.certificates
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_certificates_view_instead();
