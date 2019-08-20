CREATE TRIGGER set_global_id
  BEFORE INSERT
  ON api.courses
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.md5_url();

CREATE TRIGGER course_normalize_languages
  BEFORE INSERT OR UPDATE
  ON api.courses
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.course_normalize_languages();

CREATE TRIGGER sort_prices
  BEFORE INSERT OR UPDATE
  ON api.courses
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.sort_prices();

CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON api.courses
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
