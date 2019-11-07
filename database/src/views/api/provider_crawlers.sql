CREATE OR REPLACE VIEW api.provider_crawlers AS
  SELECT *
  FROM app.provider_crawlers
  WHERE
    (
      status != 'deleted' AND if_user_by_ids(user_account_ids, TRUE)
    ) OR if_admin(TRUE);

CREATE OR REPLACE FUNCTION triggers.api_provider_crawlers_view_instead_of_insert() RETURNS trigger AS $$
DECLARE
  new_record RECORD;
BEGIN
  IF current_user = 'user' THEN
    INSERT INTO app.provider_crawlers (
      provider_id,
      user_account_ids,
      sitemaps
    ) VALUES (
      NEW.provider_id,
      ARRAY[current_setting('request.jwt.claim.sub',true)::bigint],
      COALESCE(NEW.sitemaps, '{}')
    ) RETURNING * INTO new_record;

    RETURN new_record;
  END IF;

  IF if_admin(TRUE) THEN
    INSERT INTO app.provider_crawlers (
      user_agent_token,
      provider_id,
      published,
      status,
      user_account_ids,
      sitemaps
    ) VALUES (
      COALESCE(NEW.user_agent_token, public.uuid_generate_v4()),
      NEW.provider_id,
      COALESCE(NEW.published, false),
      COALESCE(NEW.status, 'unverified'),
      COALESCE(NEW.user_account_ids, '{}'),
      COALESCE(NEW.sitemaps, '{}')
    ) RETURNING * INTO new_record;

    RETURN new_record;
  END IF;

  RAISE insufficient_privilege;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_provider_crawlers_view_instead_of_insert
  INSTEAD OF INSERT
  ON api.provider_crawlers
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_provider_crawlers_view_instead_of_insert();

CREATE OR REPLACE FUNCTION triggers.api_provider_crawlers_view_instead_of_update() RETURNS trigger AS $$
DECLARE
  new_record RECORD;
BEGIN
  IF if_user_by_ids(OLD.user_account_ids, TRUE) THEN
    UPDATE app.provider_crawlers
    SET
      user_account_ids = NEW.user_account_ids,
      sitemaps         = NEW.sitemaps
    WHERE
      id = OLD.id
    RETURNING * INTO new_record;

    RETURN new_record;
  END IF;

  IF if_admin(TRUE) THEN
    UPDATE app.provider_crawlers
    SET
      user_agent_token = NEW.user_agent_token,
      provider_id      = NEW.provider_id,
      published        = NEW.published,
      status           = NEW.status,
      user_account_ids = NEW.user_account_ids,
      sitemaps         = NEW.sitemaps
    WHERE
      id = OLD.id
    RETURNING * INTO new_record;

    RETURN new_record;
  END IF;

  RAISE insufficient_privilege;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_provider_crawlers_view_instead_of_update
  INSTEAD OF UPDATE
  ON api.provider_crawlers
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_provider_crawlers_view_instead_of_update();

CREATE OR REPLACE FUNCTION triggers.api_provider_crawlers_view_instead_of_delete() RETURNS trigger AS $$
DECLARE
  new_record RECORD;
BEGIN
  IF if_admin(TRUE) OR if_user_by_ids(OLD.user_account_ids, TRUE) THEN
    UPDATE app.provider_crawlers
    SET status = 'deleted'
    WHERE
      id = OLD.id
    RETURNING * INTO new_record;

    RETURN OLD;
  END IF;

  RAISE insufficient_privilege;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_provider_crawlers_view_instead_of_delete
  INSTEAD OF DELETE
  ON api.provider_crawlers
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_provider_crawlers_view_instead_of_delete();
