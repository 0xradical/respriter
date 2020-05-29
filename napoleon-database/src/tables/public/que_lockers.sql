CREATE UNLOGGED TABLE public.que_lockers (
  pid               int     PRIMARY KEY,
  worker_count      int     NOT NULL,
  worker_priorities int[]   NOT NULL,
  ruby_pid          int     NOT NULL,
  ruby_hostname     text    NOT NULL,
  queues            text[]  NOT NULL,
  listening         boolean NOT NULL,

  CONSTRAINT valid_queues
  CHECK (((array_ndims(queues) = 1) AND (array_length(queues, 1) IS NOT NULL))),

  CONSTRAINT valid_worker_priorities
  CHECK (((array_ndims(worker_priorities) = 1) AND (array_length(worker_priorities, 1) IS NOT NULL)))
);
