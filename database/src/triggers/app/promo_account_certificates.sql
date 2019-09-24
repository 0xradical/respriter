CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.promo_account_certificates
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
