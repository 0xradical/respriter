CREATE INDEX index_courses_on_curated_tags
ON app.courses
USING gin (curated_tags);

CREATE INDEX index_courses_on_dataset_sequence
ON app.courses
USING btree (dataset_sequence);

CREATE UNIQUE INDEX index_courses_on_global_sequence
ON app.courses
USING btree (global_sequence);

CREATE INDEX index_courses_on_provider_id
ON app.courses
USING btree (provider_id);

CREATE INDEX index_courses_on_provider_id_published
ON app.courses
USING btree (provider_id)
WHERE published = true;

CREATE INDEX index_courses_on_tags
ON app.courses
USING gin (tags);

CREATE UNIQUE INDEX index_courses_on_slug
ON app.courses
USING btree (slug)
WHERE published = true;

CREATE UNIQUE INDEX index_courses_on_url
ON app.courses
USING btree (url)
WHERE published = true;

CREATE INDEX index_courses_on_up_to_date_id
ON app.courses
USING btree (up_to_date_id);
