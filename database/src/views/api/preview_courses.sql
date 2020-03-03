CREATE OR REPLACE VIEW api.preview_courses AS
  SELECT course.*
  FROM app.preview_courses AS course
  WHERE
    (
      current_user = 'user'
      AND EXISTS (
        SELECT 1
        FROM app.provider_crawlers AS crawler
        WHERE
          crawler.status != 'deleted'
          AND course.provider_crawler_id = crawler.id
          AND if_user_by_ids(crawler.user_account_ids, TRUE)
      )
    ) OR current_user = 'admin';

CREATE OR REPLACE FUNCTION triggers.api_preview_courses_view_instead_of_insert() RETURNS trigger AS $$
DECLARE
  preview_course RECORD;
  provider_id bigint;
BEGIN
  preview_course := NEW;

  preview_course.id := COALESCE(preview_course.id, public.uuid_generate_v4());
  preview_course.status := 'pending';

  SELECT app.provider_crawlers.provider_id FROM app.provider_crawlers WHERE app.provider_crawlers.id = preview_course.provider_crawler_id INTO provider_id;

  INSERT INTO app.preview_courses (id, status, url, provider_crawler_id, provider_id)
  VALUES (preview_course.id, preview_course.status, preview_course.url, preview_course.provider_crawler_id, provider_id);

  INSERT INTO public.que_jobs
    (queue, priority, run_at, job_class, args, data)
    VALUES
    (
      'default',
      100,
      NOW(),
      'Developers::PreviewCourseProcessorJob',
      ('["' || preview_course.id || '"]')::jsonb,
      '{}'::jsonb
    );

  RETURN preview_course;

  RAISE insufficient_privilege;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;

CREATE TRIGGER api_preview_courses_view_instead_of_insert
  INSTEAD OF INSERT OR UPDATE
  ON api.preview_courses
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_preview_courses_view_instead_of_insert();
