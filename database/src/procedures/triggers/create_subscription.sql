CREATE OR REPLACE FUNCTION triggers.create_subscription() RETURNS trigger AS $$
BEGIN
  INSERT INTO app.subscriptions (profile_id) VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
