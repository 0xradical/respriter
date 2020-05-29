CREATE OR REPLACE VIEW api.resource_versions AS
  SELECT
    id,
    resource_id,
    dataset_sequence,
    dataset_id,
    sequence,
    status,
    created_at,
    updated_at,
    unique_id,
    kind,
    schema_version,
    content,
    relations,
    extra,
    last_execution_id
  FROM app.resource_versions
  WHERE
    if_dataset_id(dataset_id, TRUE);
