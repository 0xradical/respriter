CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.provider_crawlers
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();

CREATE CONSTRAINT TRIGGER validate_user_account_ids
  AFTER INSERT OR UPDATE
  ON app.provider_crawlers
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.validate_user_account_ids();

CREATE CONSTRAINT TRIGGER validate_sitemaps
  AFTER INSERT OR UPDATE
  ON app.provider_crawlers
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.validate_sitemaps();
