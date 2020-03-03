CREATE OR REPLACE VIEW api.crawler_domains AS
  SELECT COALESCE( if_admin(crawler_domain.id),                            if_user_by_ids(crawler.user_account_ids, crawler_domain.id) ) AS id,
         crawler_domain.provider_crawler_id AS provider_crawler_id,
         crawler_domain.authority_confirmation_status AS authority_confirmation_status,
         COALESCE( if_admin(crawler_domain.authority_confirmation_token),  if_user_by_ids(crawler.user_account_ids, crawler_domain.authority_confirmation_token) ) AS authority_confirmation_token,
         COALESCE( if_admin(crawler_domain.authority_confirmation_method), if_user_by_ids(crawler.user_account_ids, crawler_domain.authority_confirmation_method) ) AS authority_confirmation_method,
         COALESCE( if_admin(crawler_domain.created_at),                    if_user_by_ids(crawler.user_account_ids, crawler_domain.created_at) ) AS created_at,
         COALESCE( if_admin(crawler_domain.updated_at),                    if_user_by_ids(crawler.user_account_ids, crawler_domain.updated_at) ) AS updated_at,
         crawler_domain.domain AS domain,
         COALESCE( if_admin(crawler_domain.authority_confirmation_salt),   if_user_by_ids(crawler.user_account_ids, crawler_domain.authority_confirmation_salt) ) AS authority_confirmation_salt
  FROM app.crawler_domains AS crawler_domain
  LEFT OUTER JOIN app.provider_crawlers AS crawler ON crawler.id = crawler_domain.provider_crawler_id
  ORDER BY id NULLS LAST;

CREATE OR REPLACE FUNCTION triggers.api_crawler_domains_view_instead_of_insert() RETURNS trigger AS $$
DECLARE
  crawler_domain RECORD;
  crawler RECORD;
  current_user_id bigint;
  log_session_id text;
BEGIN
  current_user_id := current_setting('request.jwt.claim.sub', true)::bigint;
  log_session_id := current_setting('request.header.sessionid', true)::text;

  IF if_admin(TRUE) THEN
    INSERT INTO app.crawler_domains (
      provider_crawler_id,
      authority_confirmation_status,
      domain
    ) VALUES (
      NEW.provider_crawler_id,
      COALESCE(NEW.authority_confirmation_status, 'unconfirmed'),
      NEW.domain
    ) RETURNING * INTO crawler_domain;

    RETURN crawler_domain;
  END IF;

  SELECT app.provider_crawlers.* FROM app.crawler_domains
  INNER JOIN app.provider_crawlers ON app.provider_crawlers.id = app.crawler_domains.provider_crawler_id
  WHERE app.crawler_domains.domain = NEW.domain AND app.provider_crawlers.status != 'deleted'
  LIMIT 1 INTO crawler;

  -- check for existing domains
  IF crawler IS NOT NULL THEN
    -- if there's one already for another user
    IF current_user_id != ALL(COALESCE(crawler.user_account_ids, ARRAY[]::int[])) THEN
      RAISE insufficient_privilege
        USING DETAIL = 'error', HINT = 'already_validated';
    -- if there's one already for me
    ELSE
      SELECT app.crawler_domains.* FROM app.crawler_domains
      WHERE app.crawler_domains.domain = NEW.domain
      LIMIT 1 INTO crawler_domain;

      RETURN crawler_domain;
    END IF;
  ELSE
    INSERT INTO app.crawler_domains (
      domain
    ) VALUES (
      NEW.domain
    ) ON CONFLICT ( domain ) DO UPDATE SET authority_confirmation_status = 'unconfirmed'
    RETURNING * INTO crawler_domain;

    IF crawler_domain.id IS NULL THEN
      SELECT * FROM app.crawler_domains
      WHERE app.crawler_domains.domain = NEW.domain
      LIMIT 1 INTO crawler_domain;
    END IF;

    INSERT INTO public.que_jobs
      (queue, priority, run_at, job_class, args, data)
      VALUES
      (
        'default',
        100,
        NOW(),
        'Developers::DomainAuthorityVerificationJob',
        ('["' || crawler_domain.id || '","' || current_user_id  ||  '","' || log_session_id || '"]')::jsonb,
        '{}'::jsonb
      );

    RETURN crawler_domain;
  END IF;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;

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
$$ SECURITY DEFINER LANGUAGE plpgsql;

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
    SET authority_confirmation_status = 'deleted'
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

  RAISE insufficient_privilege;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_crawler_domains_view_instead_of_delete
  INSTEAD OF DELETE
  ON api.crawler_domains
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_crawler_domains_view_instead_of_delete();