CREATE OR REPLACE FUNCTION public.if_admin(value anyelement) RETURNS anyelement AS $$
BEGIN
  IF current_user = 'admin' THEN
    RETURN value;
  ELSE
    RETURN NULL;
  END IF;
END;
$$ LANGUAGE plpgsql STABLE;
