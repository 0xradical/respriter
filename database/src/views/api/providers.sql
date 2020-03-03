CREATE OR REPLACE VIEW api.providers AS
  SELECT *
  FROM app.providers AS provider
  WHERE
    (
      current_user = 'user'
      AND EXISTS (
        SELECT 1
        FROM app.provider_crawlers AS crawler
        WHERE
          crawler.status != 'deleted'
          AND crawler.provider_id = provider.id
          AND if_user_by_ids(crawler.user_account_ids, TRUE)
      )
    ) OR current_user = 'admin';

CREATE OR REPLACE FUNCTION triggers.api_providers_view_instead_of_update() RETURNS trigger AS $$
DECLARE
  new_record RECORD;
  new_name CITEXT;
  new_name_changed_at TIMESTAMPTZ;
  new_name_dirty BOOLEAN;
BEGIN
  IF NEW.name IS NOT NULL THEN
    IF NEW.name ~ E'[\\s!\"\'#$%&()*+,\-./:;<=>?\[\\\\\\]^_`~]+' THEN
    RAISE EXCEPTION '%', 'error'
        USING DETAIL = 'name is invalid', HINT = 'forbidden characters present';
    END IF;

    IF LENGTH(NEW.name) > 50 THEN
      RAISE EXCEPTION '%', 'error'
        USING DETAIL = 'name is invalid', HINT = 'length is greater than 50';
    END IF;
  END IF;

  IF current_user = 'user' THEN
    IF NEW.name IS NOT NULL AND (OLD.name_changed_at IS NULL OR AGE(OLD.name_changed_at) > '5 days') THEN
      new_name := NEW.name;
      new_name_changed_at := NOW();
      new_name_dirty := false;
    ELSE
      new_name := OLD.name;
      new_name_changed_at := OLD.name_changed_at;
      new_name_dirty := OLD.name_dirty;
    END IF;

    UPDATE app.providers
    SET
      name            = new_name,
      name_dirty      = new_name_dirty,
      name_changed_at = new_name_changed_at,
      description     = NEW.description,
      slug            = COALESCE(OLD.slug, app.slugify(NEW.slug), app.slugify(new_name))
    WHERE
      id = OLD.id
      AND EXISTS (
        SELECT 1
        FROM app.provider_crawlers AS crawler
        WHERE
          crawler.status != 'deleted'
          AND if_user_by_ids(crawler.user_account_ids, TRUE)
          AND crawler.provider_id = app.providers.id
      )
    RETURNING * INTO new_record;

    RETURN new_record;
  END IF;

  IF if_admin(TRUE) THEN
    IF NEW.name IS NOT NULL THEN
      new_name := NEW.name;
      new_name_changed_at := NOW();
      new_name_dirty := false;
    ELSE
      new_name := OLD.name;
      new_name_changed_at := OLD.name_changed_at;
      new_name_dirty := OLD.name_dirty;
    END IF;

    UPDATE app.providers
    SET
      name                 = new_name,
      name_dirty           = new_name_dirty,
      name_changed_at      = new_name_changed_at,
      description          = NEW.description,
      slug                 = NEW.slug,
      afn_url_template     = NEW.afn_url_template,
      published            = NEW.published,
      published_at         = NEW.published_at,
      encoded_deep_linking = NEW.encoded_deep_linking
    WHERE
      id = OLD.id
    RETURNING * INTO new_record;

    RETURN new_record;
  END IF;

  RAISE insufficient_privilege;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_providers_view_instead_of_update
  INSTEAD OF UPDATE
  ON api.providers
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_providers_view_instead_of_update();
