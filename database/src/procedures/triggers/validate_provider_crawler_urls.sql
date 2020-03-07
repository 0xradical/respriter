CREATE OR REPLACE FUNCTION triggers.validate_provider_crawler_urls() RETURNS trigger AS $$
DECLARE
  result boolean;
BEGIN
  IF NEW.urls = OLD.urls THEN
    RETURN NEW;
  END IF;

  IF array_length(NEW.urls, 1) > 20 THEN
    RAISE EXCEPTION 'Invalid URLs' USING HINT = 'urls must have at most 20 elements';
  END IF;

  result = NOT EXISTS (
    SELECT 1 FROM unnest(NEW.urls) AS url
    WHERE NOT EXISTS (
      SELECT 1 FROM app.crawler_domains
      WHERE
        provider_crawler_id = NEW.id
        AND url ~ ('^https?://([a-z0-9\-\_]+\.)*' || domain || '(:\d+)?/')
    )
  );

  IF result = false THEN
    RAISE EXCEPTION 'Invalid URLs' USING HINT = 'All URLs must have verified domains';
  END IF;

  RETURN NEW;
END;
$$ SECURITY DEFINER STABLE LANGUAGE plpgsql;
