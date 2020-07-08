CREATE TABLE app.post_relations (
  id            uuid DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  relation_type varchar NOT NULL,
  relation_id   uuid NOT NULL,
  post_id       uuid REFERENCES app.posts(id)
);
