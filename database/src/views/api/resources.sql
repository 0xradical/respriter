CREATE OR REPLACE VIEW api.resources AS
  SELECT
    id,
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
  FROM app.resources
  WHERE
    if_dataset_id(dataset_id, TRUE);
