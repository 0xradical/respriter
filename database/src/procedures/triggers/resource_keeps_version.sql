CREATE FUNCTION triggers.resource_keeps_version()
RETURNS trigger AS $$
DECLARE
  new_dataset_sequence bigint;
BEGIN
  UPDATE app.datasets
  SET sequence = sequence + 1
  WHERE
    id = NEW.dataset_id
  RETURNING sequence
  INTO new_dataset_sequence;

  INSERT INTO app.resource_versions
    (
      dataset_sequence,
      sequence,
      resource_id,
      kind,
      schema_version,
      status,
      unique_id,
      content,
      relations,
      dataset_id,
      extra,
      last_execution_id,
      created_at,
      updated_at
    )
  VALUES
    (
      new_dataset_sequence,
      NEW.sequence,
      NEW.id,
      NEW.kind,
      NEW.schema_version,
      NEW.status,
      NEW.unique_id,
      NEW.content,
      NEW.relations,
      NEW.dataset_id,
      NEW.extra,
      NEW.last_execution_id,
      NEW.created_at,
      NEW.updated_at
    );

  RETURN NEW;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
