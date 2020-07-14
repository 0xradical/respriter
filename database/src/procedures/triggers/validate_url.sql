CREATE OR REPLACE FUNCTION triggers.validate_url() RETURNS trigger AS $$
DECLARE
  _protocol text;
  _host     text;
BEGIN
  IF ( NEW.url IS NOT NULL ) THEN
    WITH parsed AS (
      SELECT alias, token FROM ts_debug(NEW.url)
    )
    SELECT (SELECT token FROM parsed WHERE alias = 'protocol') AS host,
            (SELECT token FROM parsed WHERE alias = 'host') AS url_path
      INTO _protocol, _host;

    IF (_protocol IS NULL) OR (_host IS NULL) THEN
      RAISE EXCEPTION 'url update failed' USING DETAIL = 'url__invalid_uri', HINT = json_build_object('value', NEW.website);
    END IF;
  END IF;

  RETURN NEW;
END;
$$ SECURITY DEFINER STABLE LANGUAGE plpgsql;