CREATE FUNCTION triggers.insert_or_add_to_provider() RETURNS trigger AS $$
DECLARE
  _provider        api.providers%ROWTYPE;
  _new_provider_id int;
BEGIN
  SELECT * FROM api.providers INTO _provider where providers.name = NEW.__provider_name__;
  IF (NOT FOUND) THEN
    INSERT INTO api.providers (name, published, created_at, updated_at) VALUES (NEW.__provider_name__, false, NOW(), NOW()) RETURNING id INTO _new_provider_id;
    NEW.published = false;
    NEW.provider_id = _new_provider_id;
  ELSE
    NEW.provider_id = _provider.id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;