CREATE INDEX index_post_relations_on_post_id
ON app.post_relations
USING btree (post_id);

CREATE INDEX index_post_relations_on_relation_fields
ON app.post_relations
USING btree (relation_id, relation_type);

CREATE UNIQUE INDEX index_post_relations_unique
ON app.post_relations
USING btree (relation_id, relation_type, post_id);