CREATE INDEX index_pipe_processes_on_pipeline_id
ON app.pipe_processes
USING btree (pipeline_id);

CREATE INDEX index_pipe_processes_on_status
ON app.pipe_processes
USING btree (status);

CREATE INDEX index_pipe_processes_on_pipeline_id_and_status
ON app.pipe_processes
USING btree (pipeline_id, status);
