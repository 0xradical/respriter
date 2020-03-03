CREATE OR REPLACE VIEW api.preview_course_images AS
  SELECT app.preview_course_images.*
  FROM app.preview_course_images
  INNER JOIN api.preview_courses ON api.preview_courses.id = app.preview_course_images.preview_course_id;
