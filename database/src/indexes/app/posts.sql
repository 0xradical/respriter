CREATE INDEX index_posts_on_admin_account_id
ON app.posts
USING btree (admin_account_id);

CREATE INDEX index_posts_on_original_post_id
ON app.posts
USING btree (original_post_id);

CREATE UNIQUE INDEX index_posts_on_slug
ON app.posts
USING btree (slug);

CREATE INDEX index_posts_on_tags
ON app.posts
USING gin (tags);
