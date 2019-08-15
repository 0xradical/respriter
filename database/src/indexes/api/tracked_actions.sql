CREATE UNIQUE INDEX index_tracked_actions_on_compound_ext_id
ON api.tracked_actions
USING btree (compound_ext_id);

CREATE INDEX index_tracked_actions_on_enrollment_id
ON api.tracked_actions
USING btree (enrollment_id);

CREATE INDEX index_tracked_actions_on_payload
ON api.tracked_actions
USING gin (payload);

CREATE INDEX index_tracked_actions_on_status
ON api.tracked_actions
USING btree (status);
