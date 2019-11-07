CREATE OR REPLACE FUNCTION public.if_user_by_ids(ids bigint[], value anyelement) RETURNS anyelement AS $$
BEGIN
  IF current_user = 'user' AND current_setting('request.jwt.claim.sub', true)::bigint = ANY(ids) THEN
    RETURN value;
  ELSE
    RETURN NULL;
  END IF;
END;
$$ LANGUAGE plpgsql;
