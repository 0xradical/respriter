CREATE OR REPLACE VIEW subsets.tracked_actions AS (
  SELECT tracked_actions.*
  FROM app.tracked_actions
  INNER JOIN subsets.enrollments ON
    tracked_actions.enrollment_id = enrollments.id
);
