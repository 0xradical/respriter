CREATE OR REPLACE FUNCTION public.if_user_by_id(id uuid, value anyelement) RETURNS anyelement AS $$
BEGIN
  IF current_user = 'user' AND current_setting('request.jwt.claim.sub', true)::uuid = id THEN
    RETURN value;
  ELSE
    RETURN NULL;
  END IF;
END;
$$ STABLE LANGUAGE plpgsql;
