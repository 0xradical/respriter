CREATE INDEX index_profiles_on_user_account_id
ON api.profiles
USING btree (user_account_id);
