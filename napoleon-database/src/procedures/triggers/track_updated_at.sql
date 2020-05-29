CREATE FUNCTION triggers.track_updated_at() RETURNS trigger
AS $$
BEGIN
  IF NEW.updated_at IS NULL THEN
    NEW.updated_at := OLD.updated_at;
  ELSE
    IF NEW.updated_at = OLD.updated_at THEN
      NEW.updated_at := NOW();
    END IF;
  END IF;

  RETURN NEW;
END;
$$ SECURITY DEFINER LANGUAGE plpgsql;
