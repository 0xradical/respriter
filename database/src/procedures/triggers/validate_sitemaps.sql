CREATE OR REPLACE FUNCTION triggers.validate_sitemaps() RETURNS trigger AS $$
DECLARE
  result boolean;
BEGIN
  IF NEW.sitemaps = OLD.sitemaps THEN
    RETURN NEW;
  END IF;

  result = NOT EXISTS (
    SELECT 1 FROM unnest(NEW.sitemaps) AS sitemap
    WHERE NOT EXISTS (
      SELECT 1 FROM app.crawler_domains
      WHERE
        provider_crawler_id               = NEW.id
        AND authority_confirmation_status = 'confirmed'
        AND sitemap.url ~ ('^https?://([a-z0-9\-\_]+\.)*' || domain || '/')
    )
  );

  IF result = false THEN
    RAISE EXCEPTION 'Invalid sitemaps' USING HINT = 'All sitemaps must have verified domains';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
