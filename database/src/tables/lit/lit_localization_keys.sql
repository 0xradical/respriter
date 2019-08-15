CREATE TABLE lit.lit_localization_keys (
  id               serial       PRIMARY KEY,
  localization_key varchar,
  created_at       timestamptz,
  updated_at       timestamptz,
  is_completed     boolean      DEFAULT false,
  is_starred       boolean      DEFAULT false,
  is_deleted       boolean      DEFAULT false NOT NULL,
  is_visited_again boolean      DEFAULT false NOT NULL
);
