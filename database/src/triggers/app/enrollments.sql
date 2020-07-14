CREATE TRIGGER track_updated_at
  BEFORE UPDATE
  ON app.enrollments
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.track_updated_at();

CREATE TRIGGER check_course_provider_relationship
  BEFORE INSERT OR UPDATE
  ON app.enrollments
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.check_course_provider_relationship();