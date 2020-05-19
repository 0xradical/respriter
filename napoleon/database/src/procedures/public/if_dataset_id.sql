CREATE OR REPLACE FUNCTION public.if_dataset_id(id uuid, value anyelement) RETURNS anyelement AS $$
BEGIN
  IF current_setting('request.jwt.claim.dataset', true)::uuid = id THEN
    RETURN value;
  ELSE
    RETURN NULL;
  END IF;
END;
$$ STABLE LANGUAGE plpgsql;
