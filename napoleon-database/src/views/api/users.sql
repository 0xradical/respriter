CREATE OR REPLACE VIEW api.users AS
  SELECT
    id,
    username,
    NULL::varchar AS password,
    dataset_id,
    created_at,
    updated_at
  FROM app.users
  WHERE
    if_user_by_id(id,         TRUE) AND
    if_dataset_id(dataset_id, TRUE);
