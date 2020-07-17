CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.crawler_domains
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();

CREATE TRIGGER check_confirmation_status_transition
  BEFORE INSERT OR UPDATE
  ON app.crawler_domains
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.check_confirmation_status_transition();