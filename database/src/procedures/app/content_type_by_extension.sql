CREATE OR REPLACE FUNCTION app.content_type_by_extension(
  filename varchar
) RETURNS varchar AS $$
BEGIN
  CASE
  WHEN lower(filename) ~ '.(jpg|jpeg)$' THEN
    RETURN 'image/jpeg';
  WHEN lower(filename) ~ '.gif$' THEN
    RETURN 'image/gif';
  WHEN lower(filename) ~ '.png$' THEN
    RETURN 'image/png';
  WHEN lower(filename) ~ '.pdf$' THEN
    RETURN 'application/pdf';
  ELSE
    RETURN 'application/octet-stream';
  END CASE;
END;
$$ LANGUAGE plpgsql;
