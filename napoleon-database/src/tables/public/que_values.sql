CREATE TABLE public.que_values (
  key   text  PRIMARY KEY,
  value jsonb DEFAULT '{}'::jsonb NOT NULL,

  CONSTRAINT valid_value
  CHECK ((jsonb_typeof(value) = 'object'::text))
)
WITH (fillfactor='90');
