CREATE TABLE public.que_jobs (
  id                   bigserial    PRIMARY KEY,

  priority             smallint     DEFAULT 100 NOT NULL,
  run_at               timestamptz  DEFAULT NOW() NOT NULL,
  job_class            text         NOT NULL,
  error_count          integer      DEFAULT 0 NOT NULL,
  last_error_message   text,
  queue                text         DEFAULT 'default'::text NOT NULL,
  last_error_backtrace text,
  finished_at          timestamptz,
  expired_at           timestamptz,
  args                 jsonb        DEFAULT '[]'::jsonb NOT NULL,
  data                 jsonb        DEFAULT '{}'::jsonb NOT NULL,

  CONSTRAINT error_length
  CHECK (((char_length(last_error_message) <= 500) AND (char_length(last_error_backtrace) <= 10000))),

  CONSTRAINT job_class_length
  CHECK ((char_length(
CASE job_class
  WHEN 'ActiveJob::QueueAdapters::QueAdapter::JobWrapper'::text THEN ((args -> 0) ->> 'job_class'::text)
  ELSE job_class
END) <= 200)),

  CONSTRAINT queue_length
  CHECK ((char_length(queue) <= 100)),

  CONSTRAINT valid_args
  CHECK ((jsonb_typeof(args) = 'array'::text)),

  CONSTRAINT valid_data
  CHECK (((jsonb_typeof(data) = 'object'::text) AND ((NOT (data ? 'tags'::text)) OR ((jsonb_typeof((data -> 'tags'::text)) = 'array'::text) AND (jsonb_array_length((data -> 'tags'::text)) <= 5) AND public.que_validate_tags((data -> 'tags'::text))))))
)
WITH (fillfactor='90');

-- Required for migration? Maybe....
COMMENT ON TABLE public.que_jobs IS '4';
