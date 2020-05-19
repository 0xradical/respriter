CREATE FUNCTION triggers.resource_increase_sequence()
RETURNS trigger AS $$
BEGIN
  IF NEW.sequence = OLD.sequence THEN
    NEW.sequence = OLD.sequence + 1;
  END IF;
  RETURN NEW;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
