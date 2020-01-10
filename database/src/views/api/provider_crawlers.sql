CREATE OR REPLACE VIEW api.provider_crawlers AS
  SELECT *
  FROM app.provider_crawlers
  WHERE
    (
      status != 'deleted' AND if_user_by_ids(user_account_ids, TRUE)
    ) OR current_user = 'admin';

CREATE OR REPLACE FUNCTION triggers.api_provider_crawlers_view_instead_of_insert() RETURNS trigger AS $$
DECLARE
  _provider_id bigint;
  new_record   RECORD;
BEGIN
  IF current_user = 'user' THEN
    INSERT INTO app.providers DEFAULT VALUES RETURNING id INTO _provider_id;

    INSERT INTO app.provider_crawlers (
      provider_id,
      user_account_ids,
      sitemaps
    ) VALUES (
      _provider_id,
      ARRAY[current_setting('request.jwt.claim.sub',true)::bigint],
      '{}'
    ) RETURNING * INTO new_record;

    RETURN new_record;
  END IF;

  IF if_admin(TRUE) THEN
    IF NEW.provider_id IS NOT NULL THEN
      _provider_id = NEW.provider_id;
    ELSE
      INSERT INTO app.providers DEFAULT VALUES RETURNING id INTO _provider_id;
    END IF;

    INSERT INTO app.provider_crawlers (
      user_agent_token,
      provider_id,
      published,
      status,
      user_account_ids,
      sitemaps
    ) VALUES (
      COALESCE(NEW.user_agent_token, public.uuid_generate_v4()),
      _provider_id,
      COALESCE(NEW.published, false),
      COALESCE(NEW.status, 'unverified'),
      COALESCE(NEW.user_account_ids, '{}'),
      COALESCE(app.fill_sitemaps(NEW.sitemaps), '{}')
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
  sitemap app.sitemap;
  user_id bigint;
  user_role varchar;
BEGIN
  user_id := current_setting('request.jwt.claim.sub', true)::bigint;
  user_role := current_setting('request.jwt.claim.role', true)::varchar;

  IF NEW.sitemaps[1] IS NULL THEN
    sitemap := OLD.sitemaps[1];
  ELSE
    sitemap :=
      ( '(' || NEW.sitemaps[1].id  ||  ','
            || 'unverified'    ||  ','
            || NEW.sitemaps[1].url ||  ','
            || 'unknown'       ||  ')'
      )::app.sitemap;
  END IF;

  IF user_role = 'user' AND user_id = ANY(OLD.user_account_ids) THEN
    UPDATE app.provider_crawlers
    SET
      user_account_ids = NEW.user_account_ids,
      sitemaps         = ARRAY[sitemap]::app.sitemap[]
    WHERE
      id = OLD.id
    RETURNING * INTO new_record;

    INSERT INTO public.que_jobs
      (queue, priority, run_at, job_class, args, data)
      VALUES
      (
        'default',
        100,
        NOW(),
        'Developers::SitemapVerificationJob',
        ('["' || OLD.id || '","' || sitemap.id  || '"]')::jsonb,
        '{}'::jsonb
      );

    RETURN new_record;
  END IF;

  IF user_role = 'admin' THEN
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
$$ SECURITY DEFINER LANGUAGE plpgsql;

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
