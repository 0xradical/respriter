CREATE UNIQUE INDEX index_provider_logos_on_direct_upload_id
ON app.provider_logos
USING btree (direct_upload_id);

CREATE UNIQUE INDEX index_provider_logos_on_provider_id
ON app.provider_logos
USING btree (provider_id);
