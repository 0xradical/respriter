CREATE OR REPLACE FUNCTION app.sign_s3_fetch(
  region            varchar,
  host              varchar,
  bucket            varchar,
  folder            varchar,
  filename          varchar,
  access_key_id     varchar,
  secret_access_key varchar,
  expires_in        int,
  is_https          boolean
) RETURNS text AS $$
DECLARE
  canonical_request_digest text;
  string_to_sign           text;
  content_type             varchar;
  time_string              varchar;
  date_string              varchar;
  key                      bytea;
  query_string             varchar;
  signature                varchar;
  fullpath                 varchar;
  time_now                 timestamptz;
BEGIN
  time_now    = timezone('utc', NOW());
  time_string = to_char(time_now, 'YYYYMMDD"T"HH24MISSZ');
  date_string = to_char(time_now, 'YYYYMMDD');

  query_string = 'X-Amz-Algorithm=AWS4-HMAC-SHA256'
              || '&X-Amz-Credential=' || access_key_id || '%2F' || date_string || '%2F' || region || '%2Fs3%2Faws4_request'
              || '&X-Amz-Date='    || time_string
              || '&X-Amz-Expires=' || expires_in::varchar
              || '&X-Amz-SignedHeaders=host';

  canonical_request_digest = E'GET\n/'
                          || bucket || folder || '/' || filename || E'\n'
                          || query_string
                          || E'\nhost:' || host
                          || E'\n\nhost\n'
                          || 'UNSIGNED-PAYLOAD';

  string_to_sign = E'AWS4-HMAC-SHA256\n'
                || time_string || E'\n'
                || date_string || '/' || region || E'/s3/aws4_request\n'
                || encode(digest(canonical_request_digest, 'sha256'), 'hex');

  key = hmac(date_string,           'AWS4' || secret_access_key, 'sha256');
  key = hmac(region::bytea,         key,                         'sha256');
  key = hmac('s3'::bytea,           key,                         'sha256');
  key = hmac('aws4_request'::bytea, key,                         'sha256');

  signature = encode(hmac(string_to_sign::bytea, key, 'sha256'), 'hex');
  fullpath  = host || '/' || bucket || folder || '/' || filename || '?' || query_string || '&X-Amz-Signature=' || signature;

  IF is_https THEN
    RETURN 'https://' || fullpath;
  ELSE
    RETURN 'http://' || fullpath;
  END IF;
END;
$$ LANGUAGE plpgsql;
