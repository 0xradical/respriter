CREATE FUNCTION triggers.pipeline_invoke_bootstrap()
RETURNS trigger AS $$
BEGIN
  PERFORM app.invoke_sql_or_enqueue_job(
    NEW.bootstrap_script,
    NEW.bootstrap_script_type,
    'Pipeline::BootstrapJob',
    NEW
  );

  RETURN NEW;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
