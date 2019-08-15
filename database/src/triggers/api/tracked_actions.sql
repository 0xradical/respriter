CREATE TRIGGER set_compound_ext_id
  BEFORE INSERT
  ON api.tracked_actions
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.gen_compound_ext_id();

CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON api.tracked_actions
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
