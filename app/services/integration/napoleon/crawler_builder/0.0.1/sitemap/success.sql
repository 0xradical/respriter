SELECT app.pipeline_call(($1.data->>'next_pipeline_id')::uuid);
