CREATE ROLE "admin";

GRANT USAGE ON SCHEMA api      TO "admin";
GRANT USAGE ON SCHEMA app      TO "admin";
GRANT USAGE ON SCHEMA jwt      TO "admin";
GRANT USAGE ON SCHEMA settings TO "admin";

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA api TO "admin";

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON TABLE api.admin_accounts   TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON TABLE api.admin_profiles   TO "admin";
GRANT SELECT, INSERT, UPDATE,         REFERENCES ON TABLE api.courses          TO "admin";
GRANT SELECT, INSERT,         DELETE, REFERENCES ON TABLE api.enrollments      TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON TABLE api.favorites        TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON TABLE api.images           TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON TABLE api.landing_pages    TO "admin";
GRANT SELECT,         UPDATE, DELETE, REFERENCES ON TABLE api.oauth_accounts   TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON TABLE api.posts            TO "admin";
GRANT SELECT, INSERT, UPDATE,         REFERENCES ON TABLE api.profiles         TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON TABLE api.providers        TO "admin";
GRANT SELECT                                     ON TABLE api.tracked_actions  TO "admin";
GRANT SELECT                                     ON TABLE api.tracked_searches TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON TABLE api.user_accounts    TO "admin";
GRANT SELECT                                     ON TABLE api.earnings         TO "admin";
