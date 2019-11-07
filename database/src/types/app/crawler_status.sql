CREATE TYPE app.crawler_status AS ENUM (
  'unverified', 'pending', 'broken', 'active', 'deleted'
);
