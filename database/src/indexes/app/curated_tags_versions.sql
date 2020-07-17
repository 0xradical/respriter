CREATE INDEX index_curated_tags_versions_on_course_id
ON app.curated_tags_versions
USING btree (course_id);

CREATE INDEX index_curated_tags_versions_on_curated_tags
ON app.curated_tags_versions
USING gin (curated_tags);
