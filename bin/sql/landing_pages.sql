COPY (
  SELECT landing_pages.*
  FROM app.landing_pages
) TO STDOUT WITH CSV HEADER DELIMITER ',';
