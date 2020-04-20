CREATE OR REPLACE VIEW subsets.enrollments AS (
  WITH selected_enrollments AS (
    SELECT
      enrollments.*,
      ROW_NUMBER() OVER (PARTITION BY enrollments.course_id, course_filters.has_tracked_actiont ORDER BY enrollments.updated_at DESC) AS row
    FROM app.enrollments
    INNER JOIN subsets.courses ON
      enrollments.course_id = courses.id
    INNER JOIN subsets.course_filters ON
      course_filters.id = courses.id
  )

  SELECT
    id,
    user_account_id,
    course_id,
    tracked_url,
    description,
    user_rating,
    tracked_search_id,
    tracking_data,
    tracking_cookies,
    created_at,
    updated_at
  FROM selected_enrollments
  WHERE row < 8
);
