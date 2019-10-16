CREATE INDEX index_oauth_accounts_on_user_account_id
ON app.oauth_accounts
USING btree (user_account_id);
