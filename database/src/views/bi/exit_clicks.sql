CREATE MATERIALIZED VIEW bi.exit_clicks AS (

  SELECT
    DATE_TRUNC('day', enrollments.created_at)::date as date,
    enrollments.tracking_data->>'utm_source' AS utm_source,
    enrollments.tracking_data->>'utm_medium' AS utm_medium,
    enrollments.tracking_data->>'utm_campaign' AS utm_campaign,
    providers.name AS provider,
    enrollments.tracking_data->>'country' AS country,
    (courses.locale).language AS course_language,
    courses.category AS course_category,
    COUNT(DISTINCT enrollments.tracking_cookies->>'id') AS unique_clicks
  FROM
    app.enrollments
  INNER JOIN
    app.courses ON enrollments.course_id = courses.id
  INNER JOIN
    app.providers ON courses.provider_id = providers.id
  GROUP BY 1, 2, 3, 4, 5, 6, 7, 8
  ORDER BY 1

);
