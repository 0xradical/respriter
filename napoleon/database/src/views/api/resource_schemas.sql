CREATE OR REPLACE VIEW api.resource_schemas AS
  SELECT
    id,
    dataset_id,
    created_at,
    updated_at,
    kind,
    schema_version,
    specification,
    public_specification
  FROM app.resource_schemas
  WHERE
    if_dataset_id(dataset_id, TRUE);

CREATE OR REPLACE FUNCTION triggers.api_resource_schemas_instead_insert() RETURNS trigger AS $$
DECLARE
  entry RECORD;
BEGIN
  INSERT INTO app.resource_schemas (
    kind,
    schema_version,
    specification,
    public_specification,
    dataset_id
  ) VALUES (
    NEW.kind,
    NEW.schema_version,
    NEW.specification,
    NEW.public_specification,
    current_setting('request.jwt.claim.dataset', true)::uuid
  ) RETURNING
    id,
    dataset_id,
    created_at,
    updated_at,
    kind,
    schema_version,
    specification,
    public_specification
  INTO entry;

  RETURN entry;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_resource_schemas_instead_insert
  INSTEAD OF INSERT
  ON api.resource_schemas
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_resource_schemas_instead_insert();
