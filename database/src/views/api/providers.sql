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
BEGIN
  IF current_user = 'user' THEN
    UPDATE app.providers
    SET
      name                 = NEW.name,
      description          = NEW.description,
      slug                 = COALESCE(OLD.slug, app.slugify(NEW.slug), app.slugify(NEW.name)),
      afn_url_template     = NEW.afn_url_template,
      published            = NEW.published,
      published_at         = NEW.published_at,
      encoded_deep_linking = NEW.encoded_deep_linking
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
    UPDATE app.providers
    SET
      name                 = NEW.name,
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
