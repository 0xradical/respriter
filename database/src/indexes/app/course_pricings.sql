CREATE INDEX index_course_pricings_on_course_id
ON app.course_pricings
USING btree (course_id);