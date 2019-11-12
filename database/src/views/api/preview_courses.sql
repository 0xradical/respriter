CREATE OR REPLACE VIEW api.preview_courses AS
  SELECT *
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
