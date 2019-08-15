CREATE INDEX index_enrollments_on_course_id
ON api.enrollments
USING btree (course_id);

CREATE INDEX index_enrollments_on_tracked_search_id
ON api.enrollments
USING btree (tracked_search_id);

CREATE INDEX index_enrollments_on_tracking_data
ON api.enrollments
USING gin (tracking_data);

CREATE INDEX index_enrollments_on_user_account_id
ON api.enrollments
USING btree (user_account_id);
