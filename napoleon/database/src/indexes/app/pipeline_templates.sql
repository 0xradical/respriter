CREATE INDEX index_pipeline_templates_on_dataset_id
ON app.pipeline_templates
USING btree (dataset_id);
