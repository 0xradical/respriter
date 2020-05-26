CREATE INDEX index_subscriptions_on_profiles_id
ON app.subscriptions
USING btree (profile_id);