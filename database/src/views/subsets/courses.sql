CREATE MATERIALIZED VIEW subsets.course_summaries AS (
  SELECT
    courses.id,
    courses.provider_id,
    courses.category,
    courses.published,
    courses.up_to_date_id,
    courses.updated_at,
    COUNT( DISTINCT enrollments.id )                                                          AS enrollment_count,
    COUNT( DISTINCT enrollments.id ) FILTER ( WHERE enrollments.user_account_id IS NOT NULL ) AS user_accounts_count,
    COUNT( DISTINCT tracked_actions.enrollment_id )                                           AS tracked_actions_count
  FROM app.courses
  LEFT JOIN app.enrollments ON
    enrollments.course_id = courses.id
  LEFT JOIN app.tracked_actions ON
    tracked_actions.enrollment_id = enrollments.id
  GROUP BY 1, 2, 3, 4, 5, 6
);

CREATE OR REPLACE VIEW subsets.course_filters AS (
  SELECT
    id,
    provider_id,
    category,
    published,
    up_to_date_id,
    updated_at,
    CASE WHEN up_to_date_id IS NOT NULL THEN TRUE ELSE FALSE END AS has_up_to_date_id,
    CASE WHEN enrollment_count      > 0 THEN TRUE ELSE FALSE END AS has_enrollment,
    CASE WHEN user_accounts_count   > 0 THEN TRUE ELSE FALSE END AS has_user_account,
    CASE WHEN tracked_actions_count > 0 THEN TRUE ELSE FALSE END AS has_tracked_actiont
  FROM subsets.course_summaries
);

CREATE OR REPLACE VIEW subsets.courses AS (
  WITH RECURSIVE selected_courses AS (
    (
      SELECT
        filters.*,
        ROW_NUMBER() OVER (PARTITION BY provider_id, category, published, has_up_to_date_id, has_enrollment, has_user_account, has_tracked_actiont ORDER BY updated_at DESC) AS row
      FROM subsets.course_filters AS filters
     ) UNION (
      SELECT
        filters.*,
        ROW_NUMBER() OVER (PARTITION BY provider_id, category, published, has_up_to_date_id, has_enrollment, has_user_account, has_tracked_actiont ORDER BY updated_at ASC) AS row
      FROM subsets.course_filters AS filters
    ) UNION (
      SELECT
        filters.*,
        selected.row
      FROM subsets.course_filters AS filters
      INNER JOIN selected_courses AS selected ON
        selected.up_to_date_id = filters.id
    )
  )

  SELECT courses.*
  FROM (
    SELECT
      id,
      provider_id,
      category,
      published,
      up_to_date_id,
      updated_at,
      has_up_to_date_id,
      has_enrollment,
      has_user_account,
      has_tracked_actiont,
      MIN(row) AS row
    FROM selected_courses
    GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
  ) AS c
  INNER JOIN app.courses ON
    courses.id = c.id
  WHERE row <= 10
);
