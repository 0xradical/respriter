CREATE UNIQUE INDEX index_admin_accounts_on_confirmation_token
ON api.admin_accounts
USING btree (confirmation_token);

CREATE UNIQUE INDEX index_admin_accounts_on_email
ON api.admin_accounts
USING btree (email);

CREATE UNIQUE INDEX index_admin_accounts_on_reset_password_token
ON api.admin_accounts
USING btree (reset_password_token);

CREATE UNIQUE INDEX index_admin_accounts_on_unlock_token
ON api.admin_accounts
USING btree (unlock_token);
