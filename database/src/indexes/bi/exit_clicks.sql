CREATE INDEX index_exit_clicks_on_date
ON bi.exit_clicks
USING btree (date);
