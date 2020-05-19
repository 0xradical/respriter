CREATE FUNCTION app.jsonb_merge(
  jsonb,
  jsonb
) RETURNS jsonb AS $$
  SELECT
    jsonb_strip_nulls( jsonb_object_agg(k,v) )
  FROM (
    SELECT
      COALESCE(first_json.key, second_json.key) k,
      CASE
      WHEN first_json.key  IS NULL THEN second_json.value
      WHEN second_json.key IS NULL THEN first_json.value
      ELSE
        CASE
        WHEN jsonb_typeof(first_json.value)  = 'object' AND
             jsonb_typeof(second_json.value) = 'object' THEN
          app.jsonb_merge(first_json.value, second_json.value)
        ELSE
          second_json.value
        END
      END AS v
    FROM            jsonb_each($1) AS first_json
    FULL OUTER JOIN jsonb_each($2) AS second_json ON
      first_json.key = second_json.key
  ) AS pairs( k, v );
$$ STABLE LANGUAGE sql;
