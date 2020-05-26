COPY (
  SELECT *
  FROM app.orphaned_profiles
) TO STDOUT WITH CSV HEADER DELIMITER ',';
