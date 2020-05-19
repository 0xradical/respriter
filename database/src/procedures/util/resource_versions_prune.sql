CREATE FUNCTION util.resource_versions_prune()
RETURNS void AS $$
  DELETE FROM app.resource_versions AS version
  WHERE EXISTS (
    SELECT *
    FROM app.resource_versions AS latest_version
    WHERE
      version.resource_id = latest_version.resource_id AND
      version.id          < latest_version.id
  )
$$ LANGUAGE sql;
