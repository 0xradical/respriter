CREATE INDEX index_pipelines_on_dataset_id
ON app.pipelines
USING btree (dataset_id);

CREATE INDEX index_pipelines_on_pipeline_template_id
ON app.pipelines
USING btree (pipeline_template_id);

CREATE INDEX index_pipelines_on_status
ON app.pipelines
USING btree (status);

CREATE INDEX index_pipelines_on_pipeline_execution_id_and_status
ON app.pipelines
USING btree (pipeline_execution_id, status);
