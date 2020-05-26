--
-- Name: earnings; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.earnings AS
  SELECT tracked_actions.id,
    tracked_actions.sale_amount,
    tracked_actions.earnings_amount,
    tracked_actions.ext_click_date,
    tracked_actions.ext_sku_id,
    tracked_actions.ext_product_name,
    tracked_actions.ext_id,
    tracked_actions.source AS affiliate_network,
    providers.name AS provider_name,
    courses.name AS course_name,
    courses.url AS course_url,
    (enrollments.tracking_data ->> 'query_string'::text) AS qs,
    (enrollments.tracking_data ->> 'referer'::text) AS referer,
    (enrollments.tracking_data ->> 'utm_source'::text) AS utm_source,
    (enrollments.tracking_data ->> 'utm_campaign'::text) AS utm_campaign,
    (enrollments.tracking_data ->> 'utm_medium'::text) AS utm_medium,
    (enrollments.tracking_data ->> 'utm_term'::text) AS utm_term,
    (enrollments.tracking_data ->> 'country'::text) AS country,
    tracked_actions.created_at
    FROM (((public.tracked_actions
      LEFT JOIN public.enrollments ON ((tracked_actions.enrollment_id = enrollments.id)))
      LEFT JOIN public.courses ON ((enrollments.course_id = courses.id)))
      LEFT JOIN public.providers ON ((courses.provider_id = providers.id)));