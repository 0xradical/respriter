CREATE FUNCTION settings.set(varchar, varchar)
RETURNS VOID
AS $$
  INSERT INTO settings.secrets (key, value)
  VALUES ($1, $2)
  ON CONFLICT (key) DO UPDATE
  SET value = $2;
$$ SECURITY DEFINER LANGUAGE sql;
