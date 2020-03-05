CREATE TABLE app.used_usernames (
  id uuid DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  profile_id uuid REFERENCES app.profiles(id) ON DELETE CASCADE NOT NULL,
  username app.username NOT NULL
);