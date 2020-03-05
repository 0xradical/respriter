CREATE UNIQUE INDEX used_usernames_username_idx
ON app.used_usernames (username);

CREATE UNIQUE INDEX used_usernames_profile_id_username_idx
ON app.used_usernames (profile_id, username);
