COPY (
  SELECT enrollments.*
  FROM subsets.enrollments
) TO STDOUT WITH CSV HEADER DELIMITER ',';
