CREATE OR REPLACE VIEW api.crawling_events AS
  SELECT *
  FROM app.crawling_events AS event
  WHERE
    (
      current_user = 'user'
      AND EXISTS (
        SELECT 1
        FROM app.provider_crawlers AS crawler
        WHERE
          crawler.status != 'deleted'
          AND event.provider_crawler_id = crawler.id
          AND if_user_by_ids(crawler.user_account_ids, TRUE)
      )
    ) OR current_user = 'admin';
