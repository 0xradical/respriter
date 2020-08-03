CREATE INDEX index_course_categories_on_parent_id
ON app.course_categories
USING btree (parent_id);

CREATE INDEX index_course_categories_on_key
ON app.course_categories
USING btree (key);
