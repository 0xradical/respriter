CREATE FUNCTION public.que_validate_tags(tags_array jsonb) RETURNS boolean
    LANGUAGE sql
    AS $$
  SELECT bool_and(
    jsonb_typeof(value) = 'string'
    AND
    char_length(value::text) <= 100
  )
  FROM jsonb_array_elements(tags_array)
$$;
