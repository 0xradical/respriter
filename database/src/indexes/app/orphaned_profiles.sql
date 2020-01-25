CREATE UNIQUE INDEX index_orphaned_profiles_on_user_account_id
ON app.orphaned_profiles
USING btree (user_account_id);