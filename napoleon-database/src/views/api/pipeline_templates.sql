CREATE OR REPLACE VIEW api.pipeline_templates AS
  SELECT
    id,
    created_at,
    updated_at,
    max_retries,
    name,
    data,
    pipes,
    bootstrap_script_type,
    success_script_type,
    fail_script_type,
    waiting_script_type,
    bootstrap_script,
    success_script,
    fail_script,
    waiting_script
  FROM app.pipeline_templates
  WHERE
    if_dataset_id(dataset_id, TRUE);

CREATE OR REPLACE FUNCTION triggers.api_pipeline_templates_instead_insert() RETURNS trigger AS $$
DECLARE
  entry RECORD;
BEGIN
  INSERT INTO app.pipeline_templates (
    max_retries,
    name,
    data,
    pipes,
    bootstrap_script_type,
    success_script_type,
    fail_script_type,
    waiting_script_type,
    bootstrap_script,
    success_script,
    fail_script,
    waiting_script,
    dataset_id
  ) VALUES (
    COALESCE(NEW.max_retries, 5),
    NEW.name,
    NEW.data,
    NEW.pipes,
    NEW.bootstrap_script_type,
    NEW.success_script_type,
    NEW.fail_script_type,
    NEW.waiting_script_type,
    NEW.bootstrap_script,
    NEW.success_script,
    NEW.fail_script,
    NEW.waiting_script,
    current_setting('request.jwt.claim.dataset', true)::uuid
  ) RETURNING
    id,
    created_at,
    updated_at,
    max_retries,
    name,
    data,
    pipes,
    bootstrap_script_type,
    success_script_type,
    fail_script_type,
    waiting_script_type,
    bootstrap_script,
    success_script,
    fail_script,
    waiting_script
  INTO entry;

  RETURN entry;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER api_pipeline_templates_instead_insert
  INSTEAD OF INSERT
  ON api.pipeline_templates
  FOR EACH ROW
    EXECUTE PROCEDURE triggers.api_pipeline_templates_instead_insert();
