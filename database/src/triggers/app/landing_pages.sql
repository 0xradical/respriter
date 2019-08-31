CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.landing_pages
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
