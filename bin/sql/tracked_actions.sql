COPY (
  SELECT tracked_actions.*
  FROM subsets.tracked_actions
) TO STDOUT WITH CSV HEADER DELIMITER ',';
