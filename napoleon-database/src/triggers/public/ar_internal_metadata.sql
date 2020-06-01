CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON public.ar_internal_metadata
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
