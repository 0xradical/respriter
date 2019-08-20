CREATE INDEX index_tracked_searches_on_action
ON api.tracked_searches
USING btree (action);
