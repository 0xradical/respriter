COPY (
  SELECT admin_profiles.*
  FROM app.admin_profiles
) TO STDOUT WITH CSV HEADER DELIMITER ',';
