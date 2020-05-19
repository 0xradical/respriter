CREATE FUNCTION triggers.resource_validate_content()
RETURNS trigger AS $$
DECLARE
  is_valid boolean;
BEGIN
  IF NEW.schema_version IS NULL OR NEW.status != 'active' THEN
    RETURN NEW;
  END IF;

  SELECT
    json_schema.validate_json_schema(resource_schema.specification, NEW.content)
  FROM app.resource_schemas AS resource_schema
  WHERE
    kind           = NEW.kind AND
    schema_version = NEW.schema_version
  LIMIT 1
  INTO is_valid;

  IF NOT FOUND OR NOT is_valid THEN
  -- TODO: Handle resource schema errors with proper error message
    RAISE EXCEPTION 'Invalid content for resource' USING HINT = 'Invalid content for resource';
  END IF;

  RETURN NEW;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
