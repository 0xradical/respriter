CREATE INDEX index_courses_on_curated_tags
ON app.courses
USING gin (curated_tags);

CREATE INDEX index_courses_on_dataset_sequence
ON app.courses
USING btree (dataset_sequence);

CREATE INDEX index_courses_on_global_sequence
ON app.courses
USING btree (global_sequence);

CREATE INDEX index_courses_on_provider_id
ON app.courses
USING btree (provider_id);

CREATE UNIQUE INDEX index_courses_on_slug
ON app.courses
USING btree (slug);

CREATE INDEX index_courses_on_tags
ON app.courses
USING gin (tags);

CREATE UNIQUE INDEX index_courses_on_url_md5
ON app.courses
USING btree (url_md5);

CREATE INDEX index_courses_on_up_to_date_id
ON app.courses
USING btree (up_to_date_id);
