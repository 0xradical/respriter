CREATE FUNCTION triggers.track_updated_at() RETURNS trigger
AS $$
BEGIN
  IF NEW.updated_at = OLD.updated_at THEN
    NEW.updated_at := NOW();
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
