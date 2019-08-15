CREATE INDEX index_favorites_on_course_id
ON api.favorites
USING btree (course_id);

CREATE INDEX index_favorites_on_user_account_id
ON api.favorites
USING btree (user_account_id);
