CREATE VIEW api.earnings AS
  SELECT
    tracked_actions.id,
    tracked_actions.sale_amount,
    tracked_actions.earnings_amount,
    tracked_actions.ext_click_date,
    tracked_actions.ext_sku_id,
    tracked_actions.ext_product_name,
    tracked_actions.ext_id,
    tracked_actions.source                             AS affiliate_network,
    providers.name                                     AS provider_name,
    courses.name                                       AS course_name,
    courses.url                                        AS course_url,
    (enrollments.tracking_data->>'country')::text      AS country,
    (enrollments.tracking_data->>'query_string')::text AS qs,
    (enrollments.tracking_data->>'referer')::text      AS referer,
    (enrollments.tracking_data->>'utm_source')::text   AS utm_source,
    (enrollments.tracking_data->>'utm_campaign')::text AS utm_campaign,
    (enrollments.tracking_data->>'utm_medium')::text   AS utm_medium,
    (enrollments.tracking_data->>'utm_term')::text     AS utm_term,
    tracked_actions.created_at
  FROM app.tracked_actions
    LEFT JOIN app.enrollments ON enrollments.id = tracked_actions.enrollment_id
    LEFT JOIN app.courses     ON courses.id     = enrollments.course_id
    LEFT JOIN app.providers   ON providers.id   = courses.provider_id;
