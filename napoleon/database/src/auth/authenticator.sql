CREATE ROLE "authenticator" NOINHERIT login password '$AUTHENTICATOR_PASSWORD';

GRANT "user"      TO "authenticator";
GRANT "anonymous" TO "authenticator";

GRANT USAGE ON SCHEMA api      TO "authenticator";
GRANT USAGE ON SCHEMA jwt      TO "authenticator";
GRANT USAGE ON SCHEMA settings TO "authenticator";

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA app TO "authenticator";
