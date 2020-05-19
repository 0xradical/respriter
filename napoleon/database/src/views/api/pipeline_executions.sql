CREATE OR REPLACE VIEW api.pipeline_executions AS
  SELECT
    id,
    dataset_id,
    status,
    pipeline_template_id,
    schedule_interval,
    created_at,
    updated_at,
    run_at,
    counter,
    name
  FROM app.pipeline_executions
  WHERE
    if_dataset_id(dataset_id, TRUE);

CREATE OR REPLACE FUNCTION triggers.api_pipeline_executions_instead_insert() RETURNS trigger AS $$
DECLARE
  entry RECORD;
BEGIN
  INSERT INTO app.pipeline_executions (
    status,
    pipeline_template_id,
    schedule_interval,
    run_at,
    counter,
    name,
    dataset_id
  ) VALUES (
    COALESCE(NEW.status, 'pending'),
    NEW.pipeline_template_id,
    NEW.schedule_interval,
    NEW.run_at,
    COALESCE(NEW.counter, 1),
    NEW.name,
    current_setting('request.jwt.claim.dataset', true)::uuid
  ) RETURNING
    id,
    dataset_id,
    status,
    pipeline_template_id,
    schedule_interval,
    created_at,
    updated_at,
    run_at,
    counter,
    name
  INTO entry;

  RETURN entry;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_pipeline_executions_instead_insert
  INSTEAD OF INSERT
  ON api.pipeline_executions
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_pipeline_executions_instead_insert();
