CREATE FUNCTION public.que_state_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    row record;
    message json;
    previous_state text;
    current_state text;
  BEGIN
    IF TG_OP = 'INSERT' THEN
      previous_state := 'nonexistent';
      current_state  := public.que_determine_job_state(NEW);
      row            := NEW;
    ELSIF TG_OP = 'DELETE' THEN
      previous_state := public.que_determine_job_state(OLD);
      current_state  := 'nonexistent';
      row            := OLD;
    ELSIF TG_OP = 'UPDATE' THEN
      previous_state := public.que_determine_job_state(OLD);
      current_state  := public.que_determine_job_state(NEW);

      -- If the state didn't change, short-circuit.
      IF previous_state = current_state THEN
        RETURN null;
      END IF;

      row := NEW;
    ELSE
      RAISE EXCEPTION 'Unrecognized TG_OP: %', TG_OP;
    END IF;

    SELECT row_to_json(t)
    INTO message
    FROM (
      SELECT
        'job_change' AS message_type,
        row.id       AS id,
        row.queue    AS queue,

        coalesce(row.data->'tags', '[]'::jsonb) AS tags,

        to_char(row.run_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') AS run_at,
        to_char(NOW()      AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') AS time,

        CASE row.job_class
        WHEN 'ActiveJob::QueueAdapters::QueAdapter::JobWrapper' THEN
          coalesce(
            row.args->0->>'job_class',
            'ActiveJob::QueueAdapters::QueAdapter::JobWrapper'
          )
        ELSE
          row.job_class
        END AS job_class,

        previous_state AS previous_state,
        current_state  AS current_state
    ) t;

    PERFORM pg_notify('que_state', message::text);

    RETURN null;
  END
$$;
