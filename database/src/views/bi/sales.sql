CREATE MATERIALIZED VIEW bi.sales AS (

  SELECT
    DATE_TRUNC('day', tracked_actions.ext_click_date)::date as date,
    enrollments.tracking_data->>'utm_source' AS utm_source,
    enrollments.tracking_data->>'utm_medium' AS utm_medium,
    enrollments.tracking_data->>'utm_campaign' AS utm_campaign,
    tracked_actions.source AS payment_source,
    providers.name AS provider,
    enrollments.tracking_data->'country' AS country,
    (courses.locale).language AS course_language,
    courses.category AS course_category,
    SUM(tracked_actions.earnings_amount) FILTER (WHERE tracked_actions.earnings_amount > 0) AS gross_revenue,
    SUM(tracked_actions.earnings_amount) FILTER (WHERE tracked_actions.earnings_amount < 0) AS refunded_amount,
    SUM(tracked_actions.earnings_amount) AS net_income,
    COUNT(tracked_actions.id) FILTER (WHERE tracked_actions.earnings_amount > 0) AS num_sales,
    COUNT(tracked_actions.id) FILTER (WHERE tracked_actions.earnings_amount < 0) AS num_refunds
  FROM
    app.tracked_actions
  INNER JOIN
    app.enrollments ON tracked_actions.enrollment_id = enrollments.id
  INNER JOIN
    app.courses ON enrollments.course_id = courses.id
  INNER JOIN
    app.providers ON courses.provider_id = providers.id
  GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9
  ORDER BY 1

);