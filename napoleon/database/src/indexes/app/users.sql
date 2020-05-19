CREATE UNIQUE INDEX index_user_accounts_on_username
ON app.users
USING btree (username);
