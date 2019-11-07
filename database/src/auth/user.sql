CREATE ROLE "user";

GRANT USAGE ON SCHEMA api      TO "user";
GRANT USAGE ON SCHEMA app      TO "user";
GRANT USAGE ON SCHEMA jwt      TO "user";
GRANT USAGE ON SCHEMA settings TO "user";

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA app TO "user";

GRANT SELECT, INSERT, UPDATE, DELETE             ON app.certificates       TO "user";
GRANT SELECT, UPDATE                             ON app.profiles           TO "user";
GRANT SELECT, UPDATE,                 REFERENCES ON app.user_accounts      TO "user";
GRANT SELECT, INSERT, UPDATE,         REFERENCES ON app.promo_accounts     TO "user";
GRANT SELECT, INSERT, UPDATE,         REFERENCES ON app.promo_account_logs TO "user";
GRANT SELECT, INSERT, UPDATE,         REFERENCES ON app.course_reviews     TO "user";
GRANT SELECT, REFERENCES                         ON app.orphaned_profiles  TO "user";
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON app.provider_crawlers  TO "user";

GRANT SELECT, INSERT, UPDATE, DELETE ON api.certificates      TO "user";
GRANT SELECT, UPDATE                 ON api.profiles          TO "user";
GRANT SELECT, UPDATE                 ON api.user_accounts     TO "user";
GRANT SELECT, INSERT, UPDATE         ON api.promo_accounts    TO "user";
GRANT SELECT, INSERT, UPDATE, DELETE ON api.provider_crawlers TO "user";
