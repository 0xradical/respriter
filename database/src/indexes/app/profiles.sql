CREATE INDEX index_profiles_on_user_account_id
ON app.profiles
USING btree (user_account_id);

CREATE UNIQUE INDEX index_profiles_on_username
ON app.profiles
USING btree (_username);

CREATE UNIQUE INDEX profiles_username_idx
ON app.profiles (username);
