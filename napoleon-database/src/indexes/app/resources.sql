CREATE INDEX index_resources_on_dataset_id
ON app.resources
USING btree (dataset_id);

CREATE INDEX index_resources_on_dataset_id_and_kind
ON app.resources
USING btree (dataset_id, kind);

CREATE UNIQUE INDEX index_resources_on_dataset_id_and_kind_and_unique_id
ON app.resources USING btree (dataset_id, kind, unique_id);
