CREATE UNIQUE INDEX index_promo_accounts_on_user_account_id
ON app.promo_accounts
USING btree (user_account_id);