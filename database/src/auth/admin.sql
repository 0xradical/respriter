CREATE ROLE "admin";

GRANT USAGE ON SCHEMA api      TO "admin";
GRANT USAGE ON SCHEMA app      TO "admin";
GRANT USAGE ON SCHEMA jwt      TO "admin";
GRANT USAGE ON SCHEMA settings TO "admin";

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA app TO "admin";

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON app.admin_accounts            TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON app.admin_profiles            TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE             ON app.certificates              TO "admin";
GRANT SELECT, INSERT, UPDATE,         REFERENCES ON app.courses                   TO "admin";
GRANT SELECT, INSERT,         DELETE, REFERENCES ON app.enrollments               TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON app.favorites                 TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON app.images                    TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON app.landing_pages             TO "admin";
GRANT SELECT,         UPDATE, DELETE, REFERENCES ON app.oauth_accounts            TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON app.posts                     TO "admin";
GRANT SELECT, INSERT, UPDATE,         REFERENCES ON app.profiles                  TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON app.providers                 TO "admin";
GRANT SELECT                                     ON app.tracked_actions           TO "admin";
GRANT SELECT                                     ON app.tracked_searches          TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON app.user_accounts             TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON app.promo_accounts            TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON app.promo_account_logs        TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON app.course_reviews            TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON app.orphaned_profiles         TO "admin";

GRANT SELECT ON api.earnings       TO "admin";

GRANT SELECT, INSERT, UPDATE, DELETE ON api.admin_accounts             TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE ON api.certificates               TO "admin";
GRANT SELECT,         UPDATE         ON api.profiles                   TO "admin";
GRANT SELECT,         UPDATE, DELETE ON api.user_accounts              TO "admin";
GRANT SELECT, INSERT, UPDATE, DELETE ON api.promo_accounts             TO "admin";

