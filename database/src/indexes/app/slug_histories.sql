CREATE UNIQUE INDEX index_slug_histories_on_course_id_and_slug
ON app.slug_histories
USING btree (course_id, slug);
