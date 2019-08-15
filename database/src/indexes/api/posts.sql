CREATE INDEX index_posts_on_admin_account_id
ON api.posts
USING btree (admin_account_id);

CREATE INDEX index_posts_on_original_post_id
ON api.posts
USING btree (original_post_id);

CREATE UNIQUE INDEX index_posts_on_slug
ON api.posts
USING btree (slug);

CREATE INDEX index_posts_on_tags
ON api.posts
USING gin (tags);
