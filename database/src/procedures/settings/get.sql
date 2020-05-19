CREATE FUNCTION settings.get(varchar)
RETURNS varchar
AS $$
  SELECT value
  FROM settings.secrets
  WHERE key = $1
$$ SECURITY DEFINER STABLE LANGUAGE sql;
