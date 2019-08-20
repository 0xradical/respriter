CREATE TABLE api.user_accounts (
  id                     bigserial    PRIMARY KEY,
  email                  varchar      DEFAULT ''::varchar NOT NULL,
  encrypted_password     varchar      DEFAULT ''::varchar NOT NULL,
  reset_password_token   varchar,
  reset_password_sent_at timestamptz,
  remember_created_at    timestamptz,
  sign_in_count          integer      DEFAULT 0           NOT NULL,
  current_sign_in_at     timestamptz,
  last_sign_in_at        timestamptz,
  current_sign_in_ip     inet,
  last_sign_in_ip        inet,
  tracking_data          json         DEFAULT '{}'::json  NOT NULL,
  confirmation_token     varchar,
  confirmed_at           timestamptz,
  confirmation_sent_at   timestamptz,
  unconfirmed_email      varchar,
  failed_attempts        integer      DEFAULT 0           NOT NULL,
  unlock_token           varchar,
  locked_at              timestamptz,
  destroyed_at           timestamptz,
  created_at             timestamptz  DEFAULT NOW()       NOT NULL,
  updated_at             timestamptz  DEFAULT NOW()       NOT NULL
);
