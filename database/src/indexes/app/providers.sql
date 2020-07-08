CREATE UNIQUE INDEX index_providers_on_name
ON app.providers
USING btree (name);

CREATE UNIQUE INDEX index_providers_on_slug
ON app.providers
USING btree (slug);

CREATE INDEX index_providers_on_old_id
ON app.providers
USING btree (old_id)
WHERE old_id IS NOT NULL;
