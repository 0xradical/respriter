CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.crawler_domains
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
