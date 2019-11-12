CREATE OR REPLACE VIEW api.crawler_domains AS
  SELECT *
  FROM app.crawler_domains AS crawler_domain
  WHERE
    (
      current_user = 'user'
      AND EXISTS (
        SELECT 1
        FROM app.provider_crawlers AS crawler
        WHERE
          crawler.status != 'deleted'
          AND crawler_domain.provider_crawler_id = crawler.id
          AND if_user_by_ids(crawler.user_account_ids, TRUE)
      )
    ) OR current_user = 'admin';

CREATE OR REPLACE FUNCTION triggers.api_crawler_domains_view_instead_of_insert() RETURNS trigger AS $$
DECLARE
  new_record RECORD;
BEGIN
  IF current_user = 'user' THEN
    INSERT INTO app.crawler_domains (
      provider_crawler_id,
      domain
    ) VALUES (
      NEW.provider_crawler_id,
      NEW.domain
    ) RETURNING * INTO new_record;

    RETURN new_record;
  END IF;

  IF if_admin(TRUE) THEN
    INSERT INTO app.crawler_domains (
      provider_crawler_id,
      authority_confirmation_status,
      domain
    ) VALUES (
      NEW.provider_crawler_id,
      COALESCE(NEW.authority_confirmation_status, 'unconfirmed'),
      NEW.domain
    ) RETURNING * INTO new_record;

    RETURN new_record;
  END IF;

  RAISE insufficient_privilege;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_crawler_domains_view_instead_of_insert
  INSTEAD OF INSERT
  ON api.crawler_domains
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_crawler_domains_view_instead_of_insert();

CREATE OR REPLACE FUNCTION triggers.api_crawler_domains_view_instead_of_update() RETURNS trigger AS $$
DECLARE
  new_record RECORD;
BEGIN
  IF if_admin(TRUE) THEN
    UPDATE app.crawler_domains
    SET
      provider_crawler_id           = NEW.provider_crawler_id,
      authority_confirmation_status = NEW.authority_confirmation_status,
      authority_confirmation_token  = NEW.authority_confirmation_token,
      authority_confirmation_method = NEW.authority_confirmation_method,
      domain                        = NEW.domain
    WHERE
      id = OLD.id
    RETURNING * INTO new_record;

    RETURN new_record;
  END IF;

  RAISE insufficient_privilege;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_crawler_domains_view_instead_of_update
  INSTEAD OF UPDATE
  ON api.crawler_domains
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_crawler_domains_view_instead_of_update();

CREATE OR REPLACE FUNCTION triggers.api_crawler_domains_view_instead_of_delete() RETURNS trigger AS $$
DECLARE
  new_record RECORD;
BEGIN
  IF if_admin(TRUE) THEN
    UPDATE app.crawler_domains
    SET status = 'deleted'
    WHERE
      id = OLD.id;

    RETURN OLD;
  END IF;

  SELECT *
  FROM api.provider_crawlers AS crawler
  WHERE
    crawler.id = OLD.provider_crawler_id
  INTO new_record;

  IF NOT FOUND THEN
    RAISE insufficient_privilege;
  END IF;

  IF if_user_by_ids(new_record.user_account_ids, TRUE) THEN
    UPDATE app.crawler_domains
    SET status = 'deleted'
    WHERE
      id = OLD.id;

    RETURN OLD;
  END IF;

  RAISE insufficient_privilege;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_crawler_domains_view_instead_of_delete
  INSTEAD OF DELETE
  ON api.crawler_domains
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_crawler_domains_view_instead_of_delete();
