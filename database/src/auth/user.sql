CREATE ROLE "user";

GRANT USAGE ON SCHEMA api      TO "user";
GRANT USAGE ON SCHEMA app      TO "user";
GRANT USAGE ON SCHEMA jwt      TO "user";
GRANT USAGE ON SCHEMA settings TO "user";

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA app TO "user";

GRANT SELECT( id, username,           dataset_id, created_at, updated_at ) ON app.users TO "user";
GRANT UPDATE( id, username, password                                     ) ON app.users TO "user";
GRANT SELECT( id, username, password, dataset_id, created_at, updated_at ) ON api.users TO "user";
GRANT UPDATE( id, username, password                                     ) ON api.users TO "user";

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON TABLE app.pipeline_templates TO "user";
GRANT SELECT, INSERT,         DELETE, REFERENCES ON TABLE api.pipeline_templates TO "user";
GRANT UPDATE(
  name,
  data,
  pipes,
  max_retries,
  bootstrap_script_type,
  success_script_type,
  fail_script_type,
  waiting_script_type,
  bootstrap_script,
  success_script,
  fail_script,
  waiting_script
) ON api.pipeline_templates TO "user";

GRANT SELECT, INSERT, DELETE, REFERENCES ON TABLE app.pipeline_executions TO "user";
GRANT SELECT, INSERT, DELETE, REFERENCES ON TABLE api.pipeline_executions TO "user";

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON TABLE app.resource_schemas TO "user";
GRANT SELECT, INSERT,         DELETE, REFERENCES ON TABLE api.resource_schemas TO "user";
GRANT UPDATE(
  kind,
  schema_version,
  specification
) ON api.resource_schemas TO "user";

GRANT SELECT ON TABLE app.resources TO "user";
GRANT SELECT ON TABLE api.resources TO "user";

GRANT SELECT ON TABLE app.resource_versions TO "user";
GRANT SELECT ON TABLE api.resource_versions TO "user";
