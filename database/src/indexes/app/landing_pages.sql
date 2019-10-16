CREATE UNIQUE INDEX index_landing_pages_on_slug
ON app.landing_pages
USING btree (slug);
