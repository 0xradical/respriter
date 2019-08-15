CREATE INDEX index_courses_on_curated_tags
ON api.courses
USING gin (curated_tags);

CREATE INDEX index_courses_on_dataset_sequence
ON api.courses
USING btree (dataset_sequence);

CREATE INDEX index_courses_on_global_sequence
ON api.courses
USING btree (global_sequence);

CREATE INDEX index_courses_on_provider_id
ON api.courses
USING btree (provider_id);

CREATE UNIQUE INDEX index_courses_on_slug
ON api.courses
USING btree (slug);

CREATE INDEX index_courses_on_tags
ON api.courses
USING gin (tags);

CREATE UNIQUE INDEX index_courses_on_url_md5
ON api.courses
USING btree (url_md5);
