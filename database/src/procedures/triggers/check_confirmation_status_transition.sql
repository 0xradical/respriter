CREATE FUNCTION triggers.check_confirmation_status_transition() RETURNS trigger AS $$
BEGIN
  -- illegal transitions
  IF (OLD.authority_confirmation_status = 'confirmed' AND NEW.authority_confirmation_status <> 'confirmed') THEN
    RAISE EXCEPTION 'update failed' USING DETAIL = 'crawler_domain__illegal_transition', HINT = json_build_object('from', OLD.authority_confirmation_status, 'to', NEW.authority_confirmation_status);
  ELSE
    RETURN NEW;
  END IF;
END
$$ SECURITY DEFINER LANGUAGE plpgsql;
