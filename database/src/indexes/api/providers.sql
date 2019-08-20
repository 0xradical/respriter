CREATE UNIQUE INDEX index_providers_on_name
ON api.providers
USING btree (name);

CREATE UNIQUE INDEX index_providers_on_slug
ON api.providers
USING btree (slug);
