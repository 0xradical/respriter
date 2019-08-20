CREATE FUNCTION triggers.md5_url() RETURNS trigger AS $$
BEGIN
  NEW.url_md5=md5(NEW.url);
  return NEW;
END
$$ LANGUAGE plpgsql;
