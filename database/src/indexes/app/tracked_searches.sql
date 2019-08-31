CREATE INDEX index_tracked_searches_on_action
ON app.tracked_searches
USING btree (action);
