CREATE FUNCTION app.invoke_sql_or_enqueue_job(
  _script    text,
  _type      varchar,
  _job_class varchar,
  _pipeline  app.pipelines
) RETURNS void AS $$
BEGIN
  IF _script IS NOT NULL THEN
    IF _type = 'sql' THEN
      EXECUTE _script USING _pipeline;
    ELSE
      INSERT INTO public.que_jobs (job_class, args)
      VALUES (_job_class, array_to_json(ARRAY[_pipeline.id]));
    END IF;
  END IF;
END;
$$ LANGUAGE plpgsql;
