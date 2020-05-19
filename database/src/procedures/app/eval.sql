CREATE FUNCTION app.eval(
  _expr text
) RETURNS void AS $$
BEGIN
  EXECUTE _expr;
END;
$$ LANGUAGE plpgsql;
