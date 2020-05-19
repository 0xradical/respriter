CREATE FUNCTION triggers.pipeline_setup_from_template()
RETURNS trigger AS $$
DECLARE
  template record;
BEGIN
  SELECT *
  FROM app.pipeline_templates
  WHERE id = NEW.pipeline_template_id
  INTO template;

  IF NEW.dataset_id IS NULL THEN
    NEW.dataset_id = template.dataset_id;
  END IF;

  IF NEW.max_retries IS NULL THEN
    NEW.max_retries = template.max_retries;
  END IF;

  IF NEW.name IS NULL THEN
    NEW.name = template.name;
  END IF;

  IF NEW.data IS NULL THEN
    NEW.data = template.data;
  END IF;

  IF NEW.pipes IS NULL THEN
    NEW.pipes = template.pipes;
  END IF;

  IF NEW.bootstrap_script_type IS NULL THEN
    NEW.bootstrap_script_type = template.bootstrap_script_type;
  END IF;

  IF NEW.success_script_type IS NULL THEN
    NEW.success_script_type = template.success_script_type;
  END IF;

  IF NEW.fail_script_type IS NULL THEN
    NEW.fail_script_type = template.fail_script_type;
  END IF;

  IF NEW.waiting_script_type IS NULL THEN
    NEW.waiting_script_type = template.waiting_script_type;
  END IF;

  IF NEW.bootstrap_script IS NULL THEN
    NEW.bootstrap_script = template.bootstrap_script;
  END IF;

  IF NEW.success_script IS NULL THEN
    NEW.success_script = template.success_script;
  END IF;

  IF NEW.fail_script IS NULL THEN
    NEW.fail_script = template.fail_script;
  END IF;

  IF NEW.waiting_script IS NULL THEN
    NEW.waiting_script = template.waiting_script;
  END IF;

  RETURN NEW;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
