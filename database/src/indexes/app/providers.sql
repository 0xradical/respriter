CREATE UNIQUE INDEX index_providers_on_name
ON app.providers
USING btree (name);

CREATE UNIQUE INDEX index_providers_on_slug
ON app.providers
USING btree (slug);
