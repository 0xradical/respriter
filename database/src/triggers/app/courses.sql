CREATE TRIGGER course_normalize_languages
  BEFORE INSERT OR UPDATE
  ON app.courses
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.course_normalize_languages();

CREATE TRIGGER sort_prices
  BEFORE INSERT OR UPDATE
  ON app.courses
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.sort_prices();

CREATE TRIGGER course_flatten_pricing_models
  BEFORE INSERT OR UPDATE
  ON app.courses
  FOR EACH ROW
    EXECUTE PROCEDURE trigger.course_flatten_pricing_models();

CREATE TRIGGER course_keep_slug
  AFTER INSERT OR UPDATE
  ON app.courses
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.course_keep_slug();

CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.courses
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();
