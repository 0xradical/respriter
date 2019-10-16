CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.promo_accounts
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
