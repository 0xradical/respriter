CREATE INDEX index_admin_profiles_on_admin_account_id
ON app.admin_profiles
USING btree (admin_account_id);
