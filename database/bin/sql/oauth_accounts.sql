COPY (
  SELECT
    id,
    provider,
    uid,
    jsonb_set(raw_data, '{credentials,token}', '"REDACTED_TOKEN"') AS raw_data,
    user_account_id,
    created_at,
    updated_at
  FROM app.oauth_accounts
) TO STDOUT WITH CSV HEADER DELIMITER ',';
