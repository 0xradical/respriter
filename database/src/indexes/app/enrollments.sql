CREATE INDEX index_enrollments_on_course_id
ON app.enrollments
USING btree (course_id);

CREATE INDEX index_enrollments_on_provider_id
ON app.enrollments
USING btree (provider_id);

CREATE INDEX index_enrollments_on_tracked_search_id
ON app.enrollments
USING btree (tracked_search_id);

CREATE INDEX index_enrollments_on_tracking_data
ON app.enrollments
USING gin (tracking_data);

CREATE INDEX index_enrollments_on_user_account_id
ON app.enrollments
USING btree (user_account_id);
