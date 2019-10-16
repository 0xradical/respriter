CREATE INDEX index_images_on_imageable_type_and_imageable_id
ON app.images
USING btree (imageable_type, imageable_id);
