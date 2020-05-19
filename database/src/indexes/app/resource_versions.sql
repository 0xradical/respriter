CREATE INDEX index_resource_versions_on_dataset_id
ON app.resource_versions
USING btree (dataset_id);

CREATE UNIQUE INDEX index_resource_versions_on_dataset_id_and_dataset_sequence
ON app.resource_versions
USING btree (dataset_id, dataset_sequence);

CREATE INDEX index_resource_versions_on_dataset_id_and_kind_and_unique_id
ON app.resource_versions
USING btree (dataset_id, kind, unique_id);

CREATE INDEX index_resource_versions_on_resource_id
ON app.resource_versions
USING btree (resource_id);

CREATE UNIQUE INDEX index_resource_versions_on_resource_id_and_sequence
ON app.resource_versions
USING btree (resource_id, sequence);
