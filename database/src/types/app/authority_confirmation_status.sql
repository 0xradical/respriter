CREATE TYPE app.authority_confirmation_status AS ENUM (
  'unconfirmed',
  'confirming',
  'confirmed',
  'failed',
  'deleted'
);
