SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: api; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA api;


--
-- Name: app; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA app;


--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: authority_confirmation_method; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.authority_confirmation_method AS ENUM (
    'dns',
    'html'
);


--
-- Name: authority_confirmation_status; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.authority_confirmation_status AS ENUM (
    'unconfirmed',
    'confirming',
    'confirmed',
    'failed',
    'deleted'
);


--
-- Name: category; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.category AS ENUM (
    'arts_and_design',
    'business',
    'marketing',
    'computer_science',
    'data_science',
    'language_and_communication',
    'life_sciences',
    'math_and_logic',
    'personal_development',
    'physical_science_and_engineering',
    'social_science',
    'health_and_fitness',
    'social_sciences'
);


--
-- Name: contact_reason; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.contact_reason AS ENUM (
    'customer_support',
    'bug_report',
    'feature_suggestion',
    'commercial_and_partnerships',
    'manual_profile_claim',
    'other'
);


--
-- Name: crawler_status; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.crawler_status AS ENUM (
    'unverified',
    'pending',
    'broken',
    'active',
    'deleted'
);


--
-- Name: iso3166_1_alpha2_code; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.iso3166_1_alpha2_code AS ENUM (
    'AD',
    'AE',
    'AF',
    'AG',
    'AI',
    'AL',
    'AM',
    'AO',
    'AQ',
    'AR',
    'AS',
    'AT',
    'AU',
    'AW',
    'AX',
    'AZ',
    'BA',
    'BB',
    'BD',
    'BE',
    'BF',
    'BG',
    'BH',
    'BI',
    'BJ',
    'BL',
    'BM',
    'BN',
    'BO',
    'BQ',
    'BR',
    'BS',
    'BT',
    'BV',
    'BW',
    'BY',
    'BZ',
    'CA',
    'CC',
    'CD',
    'CF',
    'CG',
    'CH',
    'CI',
    'CK',
    'CL',
    'CM',
    'CN',
    'CO',
    'CR',
    'CU',
    'CV',
    'CW',
    'CX',
    'CY',
    'CZ',
    'DE',
    'DJ',
    'DK',
    'DM',
    'DO',
    'DZ',
    'EC',
    'EE',
    'EG',
    'EH',
    'ER',
    'ES',
    'ET',
    'FI',
    'FJ',
    'FK',
    'FM',
    'FO',
    'FR',
    'GA',
    'GB',
    'GD',
    'GE',
    'GF',
    'GG',
    'GH',
    'GI',
    'GL',
    'GM',
    'GN',
    'GP',
    'GQ',
    'GR',
    'GS',
    'GT',
    'GU',
    'GW',
    'GY',
    'HK',
    'HM',
    'HN',
    'HR',
    'HT',
    'HU',
    'ID',
    'IE',
    'IL',
    'IM',
    'IN',
    'IO',
    'IQ',
    'IR',
    'IS',
    'IT',
    'JE',
    'JM',
    'JO',
    'JP',
    'KE',
    'KG',
    'KH',
    'KI',
    'KM',
    'KN',
    'KP',
    'KR',
    'KW',
    'KY',
    'KZ',
    'LA',
    'LB',
    'LC',
    'LI',
    'LK',
    'LR',
    'LS',
    'LT',
    'LU',
    'LV',
    'LY',
    'MA',
    'MC',
    'MD',
    'ME',
    'MF',
    'MG',
    'MH',
    'MK',
    'ML',
    'MM',
    'MN',
    'MO',
    'MP',
    'MQ',
    'MR',
    'MS',
    'MT',
    'MU',
    'MV',
    'MW',
    'MX',
    'MY',
    'MZ',
    'NA',
    'NC',
    'NE',
    'NF',
    'NG',
    'NI',
    'NL',
    'NO',
    'NP',
    'NR',
    'NU',
    'NZ',
    'OM',
    'PA',
    'PE',
    'PF',
    'PG',
    'PH',
    'PK',
    'PL',
    'PM',
    'PN',
    'PR',
    'PS',
    'PT',
    'PW',
    'PY',
    'QA',
    'RE',
    'RO',
    'RS',
    'RU',
    'RW',
    'SA',
    'SB',
    'SC',
    'SD',
    'SE',
    'SG',
    'SH',
    'SI',
    'SJ',
    'SK',
    'SL',
    'SM',
    'SN',
    'SO',
    'SR',
    'SS',
    'ST',
    'SV',
    'SX',
    'SY',
    'SZ',
    'TC',
    'TD',
    'TF',
    'TG',
    'TH',
    'TJ',
    'TK',
    'TL',
    'TM',
    'TN',
    'TO',
    'TR',
    'TT',
    'TV',
    'TW',
    'TZ',
    'UA',
    'UG',
    'UM',
    'US',
    'UY',
    'UZ',
    'VA',
    'VC',
    'VE',
    'VG',
    'VI',
    'VN',
    'VU',
    'WF',
    'WS',
    'XK',
    'YE',
    'YT',
    'ZA',
    'ZM',
    'ZW'
);


--
-- Name: iso639_1_alpha2_code; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.iso639_1_alpha2_code AS ENUM (
    'aa',
    'ab',
    'ae',
    'af',
    'ak',
    'am',
    'an',
    'ar',
    'as',
    'av',
    'ay',
    'az',
    'ba',
    'be',
    'bg',
    'bh',
    'bi',
    'bm',
    'bn',
    'bo',
    'br',
    'bs',
    'ca',
    'ce',
    'ch',
    'co',
    'cr',
    'cs',
    'cu',
    'cv',
    'cy',
    'da',
    'de',
    'dv',
    'dz',
    'ee',
    'el',
    'en',
    'eo',
    'es',
    'et',
    'eu',
    'fa',
    'ff',
    'fi',
    'fj',
    'fo',
    'fr',
    'fy',
    'ga',
    'gd',
    'gl',
    'gn',
    'gu',
    'gv',
    'ha',
    'he',
    'hi',
    'ho',
    'hr',
    'ht',
    'hu',
    'hy',
    'hz',
    'ia',
    'id',
    'ie',
    'ig',
    'ii',
    'ik',
    'io',
    'is',
    'it',
    'iu',
    'ja',
    'jv',
    'ka',
    'kg',
    'ki',
    'kj',
    'kk',
    'kl',
    'km',
    'kn',
    'ko',
    'kr',
    'ks',
    'ku',
    'kv',
    'kw',
    'ky',
    'la',
    'lb',
    'lg',
    'li',
    'ln',
    'lo',
    'lt',
    'lu',
    'lv',
    'mg',
    'mh',
    'mi',
    'mk',
    'ml',
    'mn',
    'mr',
    'ms',
    'mt',
    'my',
    'na',
    'nb',
    'nd',
    'ne',
    'ng',
    'nl',
    'nn',
    'no',
    'nr',
    'nv',
    'ny',
    'oc',
    'oj',
    'om',
    'or',
    'os',
    'pa',
    'pi',
    'pl',
    'ps',
    'pt',
    'qu',
    'rm',
    'rn',
    'ro',
    'ru',
    'rw',
    'sa',
    'sc',
    'sd',
    'se',
    'sg',
    'si',
    'sk',
    'sl',
    'sm',
    'sn',
    'so',
    'sq',
    'sr',
    'ss',
    'st',
    'su',
    'sv',
    'sw',
    'ta',
    'te',
    'tg',
    'th',
    'ti',
    'tk',
    'tl',
    'tn',
    'to',
    'tr',
    'ts',
    'tt',
    'tw',
    'ty',
    'ug',
    'uk',
    'ur',
    'uz',
    've',
    'vi',
    'vo',
    'wa',
    'wo',
    'xh',
    'yi',
    'yo',
    'za',
    'zh',
    'zu'
);


--
-- Name: iso639_code; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.iso639_code AS ENUM (
    'ar-EG',
    'ar-JO',
    'ar-LB',
    'ar-SY',
    'de-DE',
    'en-AU',
    'en-BZ',
    'en-CA',
    'en-GB',
    'en-IN',
    'en-NZ',
    'en-US',
    'en-ZA',
    'es-AR',
    'es-BO',
    'es-CL',
    'es-CO',
    'es-EC',
    'es-ES',
    'es-GT',
    'es-MX',
    'es-PE',
    'es-VE',
    'fr-BE',
    'fr-CH',
    'fr-FR',
    'it-IT',
    'jp-JP',
    'nl-BE',
    'nl-NL',
    'pl-PL',
    'pt-BR',
    'pt-PT',
    'sv-SV',
    'zh-CN',
    'zh-CMN',
    'zh-HANS',
    'zh-HANT',
    'zh-TW',
    'af',
    'am',
    'ar',
    'az',
    'be',
    'bg',
    'bn',
    'bo',
    'bs',
    'ca',
    'co',
    'cs',
    'cy',
    'da',
    'de',
    'el',
    'en',
    'eo',
    'es',
    'et',
    'eu',
    'fa',
    'fi',
    'fil',
    'fr',
    'fy',
    'ga',
    'gd',
    'gl',
    'gu',
    'ha',
    'he',
    'hi',
    'hr',
    'ht',
    'hu',
    'hy',
    'id',
    'ig',
    'is',
    'it',
    'iw',
    'ja',
    'jp',
    'ka',
    'kk',
    'km',
    'kn',
    'ko',
    'ku',
    'ky',
    'lb',
    'lo',
    'lt',
    'lv',
    'mg',
    'mi',
    'mk',
    'ml',
    'mn',
    'mr',
    'ms',
    'mt',
    'my',
    'nb',
    'ne',
    'nl',
    'no',
    'pa',
    'pl',
    'ps',
    'pt',
    'ro',
    'ru',
    'rw',
    'sd',
    'si',
    'sk',
    'sl',
    'sn',
    'so',
    'sq',
    'sr',
    'st',
    'sv',
    'sw',
    'ta',
    'te',
    'tg',
    'th',
    'tl',
    'tr',
    'tt',
    'uk',
    'ur',
    'uz',
    'vi',
    'xh',
    'yi',
    'yo',
    'zh',
    'zu'
);


--
-- Name: level; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.level AS ENUM (
    'beginner',
    'intermediate',
    'advanced'
);


--
-- Name: locale; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.locale AS (
	language app.iso639_1_alpha2_code,
	country app.iso3166_1_alpha2_code
);


--
-- Name: locale_status; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.locale_status AS ENUM (
    'empty_audio',
    'manually_overriden',
    'mismatch',
    'multiple_countries',
    'multiple_languages',
    'not_identifiable',
    'ok'
);


--
-- Name: pace; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.pace AS ENUM (
    'self_paced',
    'instructor_paced',
    'live_class'
);


--
-- Name: payment_source; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.payment_source AS ENUM (
    'impact_radius',
    'awin',
    'rakuten',
    'share_a_sale',
    'commission_junction',
    'zanox'
);


--
-- Name: payment_status; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.payment_status AS ENUM (
    'open',
    'locked',
    'paid'
);


--
-- Name: post_status; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.post_status AS ENUM (
    'void',
    'draft',
    'published',
    'disabled'
);


--
-- Name: preview_course_status; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.preview_course_status AS ENUM (
    'pending',
    'failed',
    'succeeded'
);


--
-- Name: provider_logo; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.provider_logo AS (
	id uuid,
	provider_id uuid,
	file character varying,
	user_account_id bigint,
	created_at timestamp with time zone,
	updated_at timestamp with time zone,
	fetch_url text,
	upload_url text,
	file_content_type character varying
);


--
-- Name: sitemap; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.sitemap AS (
	id uuid,
	status character varying,
	url character varying,
	type character varying
);


--
-- Name: source; Type: TYPE; Schema: app; Owner: -
--

CREATE TYPE app.source AS ENUM (
    'api',
    'import',
    'admin'
);


--
-- Name: username; Type: DOMAIN; Schema: app; Owner: -
--

CREATE DOMAIN app.username AS public.citext
	CONSTRAINT username__boundary_dash CHECK ((NOT ((VALUE OPERATOR(public.~*) '^-'::public.citext) OR (VALUE OPERATOR(public.~*) '-$'::public.citext))))
	CONSTRAINT username__boundary_underline CHECK ((NOT ((VALUE OPERATOR(public.~*) '^_'::public.citext) OR (VALUE OPERATOR(public.~*) '_$'::public.citext))))
	CONSTRAINT username__consecutive_dash CHECK ((NOT (VALUE OPERATOR(public.~*) '--'::public.citext)))
	CONSTRAINT username__consecutive_underline CHECK ((NOT (VALUE OPERATOR(public.~*) '__'::public.citext)))
	CONSTRAINT username__format CHECK ((NOT (VALUE OPERATOR(public.~*) '[^0-9a-zA-Z\.\-\_]'::public.citext)))
	CONSTRAINT username__length_lower CHECK ((length((VALUE)::text) >= 5))
	CONSTRAINT username__length_upper CHECK ((length((VALUE)::text) <= 15))
	CONSTRAINT username__lowercased CHECK (((VALUE)::text = lower((VALUE)::text)));


--
-- Name: admin_login(character varying, character varying); Type: FUNCTION; Schema: api; Owner: -
--

CREATE FUNCTION api.admin_login(email character varying, password character varying) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  admin_id bigint;
  result   text;
BEGIN
  SELECT
    id
  FROM app.admin_accounts
  WHERE
    app.admin_accounts.email              = admin_login.email AND
    app.admin_accounts.encrypted_password = public.crypt(admin_login.password, app.admin_accounts.encrypted_password)
  INTO admin_id;

  IF admin_id IS NULL THEN
    RAISE invalid_password USING message = 'invalid email or password';
  END IF;

  SELECT
    jwt.sign(
      row_to_json(r), settings.get('app.jwt_secret')
    ) AS token
  FROM (
    SELECT
      'admin'                                AS role,
      admin_id::varchar                      AS sub,
      extract(EPOCH FROM now())::int + 60*60 AS exp
  ) r
  INTO result;

  RETURN result;
END;
$$;


--
-- Name: user_login(character varying, character varying); Type: FUNCTION; Schema: api; Owner: -
--

CREATE FUNCTION api.user_login(email character varying, password character varying) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  user_id bigint;
  result  text;
BEGIN
  SELECT
    id
  FROM app.user_accounts
  WHERE
    app.user_accounts.email              = user_login.email AND
    app.user_accounts.encrypted_password = public.crypt(user_login.password, app.user_accounts.encrypted_password)
  INTO user_id;

  IF user_id IS NULL THEN
    RAISE invalid_password USING message = 'invalid user or password';
  END IF;

  SELECT
    jwt.sign(
      row_to_json(r), settings.get('app.jwt_secret')
    ) AS token
  FROM (
    SELECT
      'user'                                 AS role,
      user_id::varchar                       AS sub,
      extract(EPOCH FROM now())::int + 60*60 AS exp
  ) r
  INTO result;

  RETURN result;
END;
$$;


--
-- Name: content_type_by_extension(character varying); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.content_type_by_extension(filename character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
BEGIN
  CASE
  WHEN lower(filename) ~ '.(jpg|jpeg)$' THEN
    RETURN 'image/jpeg';
  WHEN lower(filename) ~ '.gif$' THEN
    RETURN 'image/gif';
  WHEN lower(filename) ~ '.png$' THEN
    RETURN 'image/png';
  WHEN lower(filename) ~ '.svg$' THEN
    RETURN 'image/svg+xml';
  WHEN lower(filename) ~ '.pdf$' THEN
    RETURN 'application/pdf';
  ELSE
    RETURN 'application/octet-stream';
  END CASE;
END;
$_$;


--
-- Name: currency_index(character varying); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.currency_index(currency character varying) RETURNS bigint
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
BEGIN
  CASE
  WHEN currency = 'USD' THEN
    RETURN 0;
  WHEN currency = 'EUR' THEN
    RETURN 1;
  WHEN currency = 'GPB' THEN
    RETURN 2;
  WHEN currency = 'BRL' THEN
    RETURN 3;
  ELSE
    RETURN 4;
  END CASE;
END;
$$;


--
-- Name: fill_sitemaps(app.sitemap[]); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.fill_sitemaps(_sitemaps app.sitemap[]) RETURNS app.sitemap[]
    LANGUAGE sql
    AS $$
  SELECT
    ARRAY_AGG(
      (
        COALESCE(sitemap.id,     public.uuid_generate_v4()),
        COALESCE(sitemap.status, 'unconfirmed'),
        sitemap.url,
        sitemap.type
      )::app.sitemap
    )
  FROM unnest(_sitemaps) AS sitemap
  WHERE
    sitemap.url IS NOT NULL
    AND char_length(sitemap.url) > 0
$$;


--
-- Name: merge_sitemaps(app.sitemap[], app.sitemap[]); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.merge_sitemaps(_old_sitemaps app.sitemap[], _new_sitemaps app.sitemap[]) RETURNS app.sitemap[]
    LANGUAGE sql
    AS $$
  SELECT
    ARRAY_AGG(
      COALESCE(old_sitemap, new_sitemap)
    )
  FROM      unnest(_new_sitemaps) AS new_sitemap
  LEFT JOIN unnest(_old_sitemaps) AS old_sitemap ON
    new_sitemap.id = old_sitemap.id
$$;


--
-- Name: new_sitemaps(app.sitemap[]); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.new_sitemaps(_sitemaps app.sitemap[]) RETURNS app.sitemap[]
    LANGUAGE sql
    AS $$
  SELECT
    ARRAY_AGG(
      (
        COALESCE(sitemap.id, public.uuid_generate_v4()),
        'unconfirmed',
        sitemap.url,
        sitemap.type
      )::app.sitemap
    )
  FROM unnest(_sitemaps) AS sitemap
  WHERE
    sitemap.url IS NOT NULL
    AND char_length(sitemap.url) > 0
$$;


--
-- Name: normalize_languages(text[]); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.normalize_languages(languages text[]) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
  upcased_languages text[];
BEGIN
  WITH

  subtitles AS (
    SELECT DISTINCT unnest(languages) AS subtitle
  ),

  subtitle_arrays AS (
    SELECT regexp_split_to_array(subtitle, '-') AS subtitle_array
    FROM subtitles
  )

  SELECT DISTINCT
    ARRAY_AGG(
      CASE WHEN array_length(subtitle_array, 1) = 2
      THEN subtitle_array[1] || '-' || upper(subtitle_array[2])
      ELSE subtitle_array[1]
      END
    )
  FROM subtitle_arrays
  INTO upcased_languages;

  RETURN upcased_languages;
END;
$$;


--
-- Name: price_in_decimal(text); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.price_in_decimal(price text) RETURNS numeric
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
   IF $1 = '' THEN  -- special case for empty string like requested
      RETURN 0::DECIMAL(12,2);
   ELSE
      RETURN $1::DECIMAL(12,2);
   END IF;

EXCEPTION WHEN OTHERS THEN
   RETURN NULL;  -- NULL for other invalid input

END
$_$;


--
-- Name: sign_certificate_s3_fetch(uuid, character varying, integer); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.sign_certificate_s3_fetch(id uuid, filename character varying, expires_in integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN app.sign_s3_fetch(
    'us-east-1',
    's3.us-east-1.amazonaws.com',
    'clspt-uploads-prd',
    '/signed/certificates',
    id::varchar || '-' || filename,
    'AKIAWS4RUC67BCMWXL4B',
    'ooymHkbCnOZjP8ySgPHEpY9PnLHuqEGWjfpQdw0S',
    expires_in,
    'TRUE'::boolean
  );
END;
$$;


--
-- Name: sign_certificate_s3_upload(uuid, character varying, integer); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.sign_certificate_s3_upload(id uuid, filename character varying, expires_in integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN app.sign_s3_upload(
    'us-east-1',
    's3.us-east-1.amazonaws.com',
    'clspt-uploads-prd',
    '/signed/certificates',
    id::varchar || '-' || filename,
    'AKIAWS4RUC67BCMWXL4B',
    'ooymHkbCnOZjP8ySgPHEpY9PnLHuqEGWjfpQdw0S',
    expires_in,
    'FALSE'::boolean,
    'TRUE'::boolean
  );
END;
$$;


--
-- Name: sign_direct_s3_fetch(uuid, character varying, character varying, integer); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.sign_direct_s3_fetch(id uuid, filename character varying, folder character varying, expires_in integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN app.sign_s3_fetch(
    'us-east-1',
    's3.us-east-1.amazonaws.com',
    'clspt-uploads-prd',
    '/signed' || '/' || folder,
    id::varchar || '-' || filename,
    'AKIAWS4RUC67BCMWXL4B',
    'ooymHkbCnOZjP8ySgPHEpY9PnLHuqEGWjfpQdw0S',
    expires_in,
    'TRUE'::boolean
  );
END;
$$;


--
-- Name: sign_direct_s3_upload(uuid, character varying, character varying, integer); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.sign_direct_s3_upload(id uuid, filename character varying, folder character varying, expires_in integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN app.sign_s3_upload(
    'us-east-1',
    's3.us-east-1.amazonaws.com',
    'clspt-uploads-prd',
    '/signed' || '/' || folder,
    id::varchar || '-' || filename,
    'AKIAWS4RUC67BCMWXL4B',
    'ooymHkbCnOZjP8ySgPHEpY9PnLHuqEGWjfpQdw0S',
    expires_in,
    'FALSE'::boolean,
    'TRUE'::boolean
  );
END;
$$;


--
-- Name: sign_s3_fetch(character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.sign_s3_fetch(region character varying, host character varying, bucket character varying, folder character varying, filename character varying, access_key_id character varying, secret_access_key character varying, expires_in integer, is_https boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
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
$$;


--
-- Name: sign_s3_upload(character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, boolean); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.sign_s3_upload(region character varying, host character varying, bucket character varying, folder character varying, filename character varying, access_key_id character varying, secret_access_key character varying, expires_in integer, is_public boolean, is_https boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  canonical_request_digest text;
  string_to_sign           text;
  acl                      varchar;
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
              || '&X-Amz-SignedHeaders=content-type%3Bhost%3Bx-amz-acl';

  content_type = app.content_type_by_extension(filename);

  IF is_public THEN
    acl = 'public-read';
  ELSE
    acl = 'private';
  END IF;

  canonical_request_digest = E'PUT\n/'
                          || bucket || folder || '/' || filename || E'\n'
                          || query_string
                          || E'\ncontent-type:' || content_type
                          || E'\nhost:' || host
                          || E'\nx-amz-acl:' || acl
                          || E'\n\ncontent-type;host;x-amz-acl\n'
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
$$;


--
-- Name: slugify(character varying); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.slugify(value character varying) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  WITH unaccented AS (
    SELECT unaccent(value) AS value
  ),

  lowercase AS (
    SELECT lower(value) AS value
    FROM unaccented
  ),

  hyphenated AS (
    SELECT regexp_replace(value, '[^a-z0-9\\-_]+', '-', 'gi') AS value
    FROM lowercase
  ),

  trimmed AS (
    SELECT regexp_replace(regexp_replace(value, '\\-+$', ''), '^\\-', '') AS value
    FROM hyphenated
  )

  SELECT value FROM trimmed;
$_$;


--
-- Name: if_admin(anyelement); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.if_admin(value anyelement) RETURNS anyelement
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  IF current_user = 'admin' THEN
    RETURN value;
  ELSE
    RETURN NULL;
  END IF;
END;
$$;


--
-- Name: if_user_by_id(bigint, anyelement); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.if_user_by_id(id bigint, value anyelement) RETURNS anyelement
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  IF current_user = 'user' AND current_setting('request.jwt.claim.sub', true)::bigint = id THEN
    RETURN value;
  ELSE
    RETURN NULL;
  END IF;
END;
$$;


--
-- Name: if_user_by_ids(bigint[], anyelement); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.if_user_by_ids(ids bigint[], value anyelement) RETURNS anyelement
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  IF current_user = 'user' AND current_setting('request.jwt.claim.sub', true)::bigint = ANY(ids) THEN
    RETURN value;
  ELSE
    RETURN NULL;
  END IF;
END;
$$;


--
-- Name: que_validate_tags(jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.que_validate_tags(tags_array jsonb) RETURNS boolean
    LANGUAGE sql
    AS $$
  SELECT bool_and(
    jsonb_typeof(value) = 'string'
    AND
    char_length(value::text) <= 100
  )
  FROM jsonb_array_elements(tags_array)
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: que_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.que_jobs (
    id bigint NOT NULL,
    priority smallint DEFAULT 100 NOT NULL,
    run_at timestamp with time zone DEFAULT now() NOT NULL,
    job_class text NOT NULL,
    error_count integer DEFAULT 0 NOT NULL,
    last_error_message text,
    queue text DEFAULT 'default'::text NOT NULL,
    last_error_backtrace text,
    finished_at timestamp with time zone,
    expired_at timestamp with time zone,
    args jsonb DEFAULT '[]'::jsonb NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT error_length CHECK (((char_length(last_error_message) <= 500) AND (char_length(last_error_backtrace) <= 10000))),
    CONSTRAINT job_class_length CHECK ((char_length(
CASE job_class
    WHEN 'ActiveJob::QueueAdapters::QueAdapter::JobWrapper'::text THEN ((args -> 0) ->> 'job_class'::text)
    ELSE job_class
END) <= 200)),
    CONSTRAINT queue_length CHECK ((char_length(queue) <= 100)),
    CONSTRAINT valid_args CHECK ((jsonb_typeof(args) = 'array'::text)),
    CONSTRAINT valid_data CHECK (((jsonb_typeof(data) = 'object'::text) AND ((NOT (data ? 'tags'::text)) OR ((jsonb_typeof((data -> 'tags'::text)) = 'array'::text) AND (jsonb_array_length((data -> 'tags'::text)) <= 5) AND public.que_validate_tags((data -> 'tags'::text))))))
)
WITH (fillfactor='90');


--
-- Name: TABLE que_jobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.que_jobs IS '4';


--
-- Name: que_determine_job_state(public.que_jobs); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.que_determine_job_state(job public.que_jobs) RETURNS text
    LANGUAGE sql
    AS $$
  SELECT
    CASE
    WHEN job.expired_at  IS NOT NULL    THEN 'expired'
    WHEN job.finished_at IS NOT NULL    THEN 'finished'
    WHEN job.error_count > 0            THEN 'errored'
    WHEN job.run_at > CURRENT_TIMESTAMP THEN 'scheduled'
    ELSE                                     'ready'
    END
$$;


--
-- Name: que_job_notify(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.que_job_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    locker_pid integer;
    sort_key json;
  BEGIN
    -- Don't do anything if the job is scheduled for a future time.
    IF NEW.run_at IS NOT NULL AND NEW.run_at > NOW() THEN
      RETURN null;
    END IF;

    -- Pick a locker to notify of the job's insertion, weighted by their number
    -- of workers. Should bounce pseudorandomly between lockers on each
    -- invocation, hence the md5-ordering, but still touch each one equally,
    -- hence the modulo using the job_id.
    SELECT pid
    INTO locker_pid
    FROM (
      SELECT *, last_value(row_number) OVER () + 1 AS count
      FROM (
        SELECT *, row_number() OVER () - 1 AS row_number
        FROM (
          SELECT *
          FROM public.que_lockers ql, generate_series(1, ql.worker_count) AS id
          WHERE listening AND queues @> ARRAY[NEW.queue]
          ORDER BY md5(pid::text || id::text)
        ) t1
      ) t2
    ) t3
    WHERE NEW.id % count = row_number;

    IF locker_pid IS NOT NULL THEN
      -- There's a size limit to what can be broadcast via LISTEN/NOTIFY, so
      -- rather than throw errors when someone enqueues a big job, just
      -- broadcast the most pertinent information, and let the locker query for
      -- the record after it's taken the lock. The worker will have to hit the
      -- DB in order to make sure the job is still visible anyway.
      SELECT row_to_json(t)
      INTO sort_key
      FROM (
        SELECT
          'job_available' AS message_type,
          NEW.queue       AS queue,
          NEW.priority    AS priority,
          NEW.id          AS id,
          -- Make sure we output timestamps as UTC ISO 8601
          to_char(NEW.run_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') AS run_at
      ) t;

      PERFORM pg_notify('que_listener_' || locker_pid::text, sort_key::text);
    END IF;

    RETURN null;
  END
$$;


--
-- Name: que_state_notify(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.que_state_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    row record;
    message json;
    previous_state text;
    current_state text;
  BEGIN
    IF TG_OP = 'INSERT' THEN
      previous_state := 'nonexistent';
      current_state  := public.que_determine_job_state(NEW);
      row            := NEW;
    ELSIF TG_OP = 'DELETE' THEN
      previous_state := public.que_determine_job_state(OLD);
      current_state  := 'nonexistent';
      row            := OLD;
    ELSIF TG_OP = 'UPDATE' THEN
      previous_state := public.que_determine_job_state(OLD);
      current_state  := public.que_determine_job_state(NEW);

      -- If the state didn't change, short-circuit.
      IF previous_state = current_state THEN
        RETURN null;
      END IF;

      row := NEW;
    ELSE
      RAISE EXCEPTION 'Unrecognized TG_OP: %', TG_OP;
    END IF;

    SELECT row_to_json(t)
    INTO message
    FROM (
      SELECT
        'job_change' AS message_type,
        row.id       AS id,
        row.queue    AS queue,

        coalesce(row.data->'tags', '[]'::jsonb) AS tags,

        to_char(row.run_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') AS run_at,
        to_char(NOW()      AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') AS time,

        CASE row.job_class
        WHEN 'ActiveJob::QueueAdapters::QueAdapter::JobWrapper' THEN
          coalesce(
            row.args->0->>'job_class',
            'ActiveJob::QueueAdapters::QueAdapter::JobWrapper'
          )
        ELSE
          row.job_class
        END AS job_class,

        previous_state AS previous_state,
        current_state  AS current_state
    ) t;

    PERFORM pg_notify('que_state', message::text);

    RETURN null;
  END
$$;


--
-- Name: admin_accounts; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.admin_accounts (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp with time zone,
    remember_created_at timestamp with time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp with time zone,
    confirmation_sent_at timestamp with time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    preferences jsonb DEFAULT '{}'::jsonb
);


--
-- Name: admin_accounts; Type: VIEW; Schema: api; Owner: -
--

CREATE VIEW api.admin_accounts AS
 SELECT admin_accounts.id,
    admin_accounts.email,
    NULL::character varying AS password,
    admin_accounts.reset_password_token,
    admin_accounts.reset_password_sent_at,
    admin_accounts.remember_created_at,
    admin_accounts.sign_in_count,
    admin_accounts.current_sign_in_at,
    admin_accounts.last_sign_in_at,
    admin_accounts.current_sign_in_ip,
    admin_accounts.last_sign_in_ip,
    admin_accounts.confirmation_token,
    admin_accounts.confirmed_at,
    admin_accounts.confirmation_sent_at,
    admin_accounts.unconfirmed_email,
    admin_accounts.failed_attempts,
    admin_accounts.unlock_token,
    admin_accounts.locked_at,
    admin_accounts.created_at,
    admin_accounts.updated_at,
    admin_accounts.preferences
   FROM app.admin_accounts;


--
-- Name: certificates; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.certificates (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_account_id bigint,
    file character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT valid_file_format CHECK ((lower((file)::text) ~ '.(gif|jpg|jpeg|png|pdf)$'::text))
);


--
-- Name: certificates; Type: VIEW; Schema: api; Owner: -
--

CREATE VIEW api.certificates AS
 SELECT certificates.id,
    certificates.user_account_id,
    certificates.file,
    certificates.created_at,
    certificates.updated_at,
    app.sign_certificate_s3_fetch(certificates.id, certificates.file, 3600) AS fetch_url,
    app.sign_certificate_s3_upload(certificates.id, certificates.file, 3600) AS upload_url,
    app.content_type_by_extension(certificates.file) AS file_content_type
   FROM app.certificates
  WHERE ((CURRENT_USER = 'admin'::name) OR ((CURRENT_USER = 'user'::name) AND ((current_setting('request.jwt.claim.sub'::text, true))::bigint = certificates.user_account_id)));


--
-- Name: crawler_domains; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.crawler_domains (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    provider_crawler_id uuid,
    authority_confirmation_status app.authority_confirmation_status DEFAULT 'unconfirmed'::app.authority_confirmation_status NOT NULL,
    authority_confirmation_token character varying,
    authority_confirmation_method app.authority_confirmation_method DEFAULT 'dns'::app.authority_confirmation_method NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    domain character varying NOT NULL,
    authority_confirmation_salt character varying,
    CONSTRAINT domain__must_be_a_domain CHECK (((domain)::text ~ '^([a-z0-9\-\_]+\.)+[a-z]+$'::text))
);


--
-- Name: provider_crawlers; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.provider_crawlers (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    user_agent_token uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    provider_id uuid,
    published boolean DEFAULT false NOT NULL,
    scheduled boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    status app.crawler_status DEFAULT 'unverified'::app.crawler_status NOT NULL,
    user_account_ids bigint[] DEFAULT '{}'::bigint[] NOT NULL,
    sitemaps app.sitemap[] DEFAULT '{}'::app.sitemap[] NOT NULL,
    version character varying,
    settings jsonb,
    urls character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    old_provider_id bigint
);


--
-- Name: crawler_domains; Type: VIEW; Schema: api; Owner: -
--

CREATE VIEW api.crawler_domains AS
 SELECT COALESCE(public.if_admin(crawler_domain.id), public.if_user_by_ids(crawler.user_account_ids, crawler_domain.id)) AS id,
    crawler_domain.provider_crawler_id,
    crawler_domain.authority_confirmation_status,
    COALESCE(public.if_admin(crawler_domain.authority_confirmation_token), public.if_user_by_ids(crawler.user_account_ids, crawler_domain.authority_confirmation_token)) AS authority_confirmation_token,
    COALESCE(public.if_admin(crawler_domain.authority_confirmation_method), public.if_user_by_ids(crawler.user_account_ids, crawler_domain.authority_confirmation_method)) AS authority_confirmation_method,
    COALESCE(public.if_admin(crawler_domain.created_at), public.if_user_by_ids(crawler.user_account_ids, crawler_domain.created_at)) AS created_at,
    COALESCE(public.if_admin(crawler_domain.updated_at), public.if_user_by_ids(crawler.user_account_ids, crawler_domain.updated_at)) AS updated_at,
    crawler_domain.domain,
    COALESCE(public.if_admin(crawler_domain.authority_confirmation_salt), public.if_user_by_ids(crawler.user_account_ids, crawler_domain.authority_confirmation_salt)) AS authority_confirmation_salt
   FROM (app.crawler_domains crawler_domain
     LEFT JOIN app.provider_crawlers crawler ON ((crawler.id = crawler_domain.provider_crawler_id)))
  ORDER BY COALESCE(public.if_admin(crawler_domain.id), public.if_user_by_ids(crawler.user_account_ids, crawler_domain.id));


--
-- Name: crawling_events; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.crawling_events (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    provider_crawler_id uuid,
    execution_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    sequence bigint,
    type character varying NOT NULL,
    data jsonb
);


--
-- Name: crawling_events; Type: VIEW; Schema: api; Owner: -
--

CREATE VIEW api.crawling_events AS
 SELECT event.id,
    event.provider_crawler_id,
    event.execution_id,
    event.created_at,
    event.updated_at,
    event.sequence,
    event.type,
    event.data
   FROM app.crawling_events event
  WHERE (((CURRENT_USER = 'user'::name) AND (EXISTS ( SELECT 1
           FROM app.provider_crawlers crawler
          WHERE ((crawler.status <> 'deleted'::app.crawler_status) AND (event.provider_crawler_id = crawler.id) AND public.if_user_by_ids(crawler.user_account_ids, true))))) OR (CURRENT_USER = 'admin'::name));


--
-- Name: courses; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.courses (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    global_sequence integer,
    name character varying,
    description text,
    slug character varying,
    url character varying,
    url_md5 character varying,
    duration_in_hours numeric,
    price numeric,
    rating numeric,
    relevance integer DEFAULT 0,
    region character varying,
    audio text[] DEFAULT '{}'::text[],
    subtitles text[] DEFAULT '{}'::text[],
    published boolean DEFAULT true,
    stale boolean DEFAULT false,
    category app.category,
    provider_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    dataset_sequence integer,
    resource_sequence integer,
    tags text[] DEFAULT '{}'::text[],
    video jsonb,
    source app.source DEFAULT 'api'::app.source,
    pace app.pace,
    certificate jsonb DEFAULT '{}'::jsonb,
    pricing_models jsonb DEFAULT '[]'::jsonb,
    offered_by jsonb DEFAULT '[]'::jsonb,
    syllabus text,
    effort integer,
    enrollments_count integer DEFAULT 0,
    free_content boolean DEFAULT false,
    paid_content boolean DEFAULT true,
    level app.level[] DEFAULT '{}'::app.level[],
    __provider_name__ character varying,
    __source_schema__ jsonb,
    instructors jsonb DEFAULT '[]'::jsonb,
    old_curated_tags character varying[] DEFAULT '{}'::character varying[],
    refinement_tags character varying[],
    up_to_date_id uuid,
    last_execution_id uuid,
    schema_version character varying,
    ignore_robots_noindex_rule_for app.locale[] DEFAULT '{}'::app.locale[],
    ignore_robots_noindex_rule boolean DEFAULT false,
    locale app.locale,
    locale_status app.locale_status,
    canonical_subdomain character varying,
    old_provider_id bigint
);


--
-- Name: enrollments; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.enrollments (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_account_id bigint,
    course_id uuid,
    tracked_url character varying,
    description text,
    user_rating numeric,
    tracked_search_id uuid,
    tracking_data jsonb DEFAULT '{}'::jsonb,
    tracking_cookies jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    provider_id uuid
);


--
-- Name: providers; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.providers (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name public.citext,
    description text,
    slug character varying,
    afn_url_template character varying,
    published boolean DEFAULT false,
    published_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    encoded_deep_linking boolean DEFAULT false,
    name_dirty boolean DEFAULT true NOT NULL,
    name_changed_at timestamp with time zone,
    url character varying,
    old_id bigint NOT NULL,
    ignore_robots_noindex_rule_for app.locale[] DEFAULT '{}'::app.locale[],
    ignore_robots_noindex_rule boolean DEFAULT false,
    featured_on_footer boolean DEFAULT false,
    CONSTRAINT providers_check CHECK ((name_dirty OR ((NOT name_dirty) AND (name_changed_at IS NOT NULL))))
);


--
-- Name: tracked_actions; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.tracked_actions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    enrollment_id uuid,
    status app.payment_status,
    source app.payment_source,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    sale_amount numeric,
    earnings_amount numeric,
    payload jsonb,
    compound_ext_id character varying,
    ext_click_date timestamp with time zone,
    ext_id character varying,
    ext_sku_id character varying,
    ext_product_name character varying
);


--
-- Name: earnings; Type: VIEW; Schema: api; Owner: -
--

CREATE VIEW api.earnings AS
 SELECT tracked_actions.id,
    tracked_actions.sale_amount,
    tracked_actions.earnings_amount,
    tracked_actions.ext_click_date,
    tracked_actions.ext_sku_id,
    tracked_actions.ext_product_name,
    tracked_actions.ext_id,
    tracked_actions.source AS affiliate_network,
    providers.name AS provider_name,
    courses.name AS course_name,
    courses.url AS course_url,
    (enrollments.tracking_data ->> 'country'::text) AS country,
    (enrollments.tracking_data ->> 'query_string'::text) AS qs,
    (enrollments.tracking_data ->> 'referer'::text) AS referer,
    (enrollments.tracking_data ->> 'utm_source'::text) AS utm_source,
    (enrollments.tracking_data ->> 'utm_campaign'::text) AS utm_campaign,
    (enrollments.tracking_data ->> 'utm_medium'::text) AS utm_medium,
    (enrollments.tracking_data ->> 'utm_term'::text) AS utm_term,
    tracked_actions.created_at
   FROM (((app.tracked_actions
     LEFT JOIN app.enrollments ON ((enrollments.id = tracked_actions.enrollment_id)))
     LEFT JOIN app.courses ON ((courses.id = enrollments.course_id)))
     LEFT JOIN app.providers ON ((providers.id = courses.provider_id)));


--
-- Name: preview_courses; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.preview_courses (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    status app.preview_course_status DEFAULT 'pending'::app.preview_course_status,
    name character varying,
    description text,
    slug character varying,
    url character varying NOT NULL,
    url_md5 character varying,
    duration_in_hours numeric,
    price numeric,
    rating numeric,
    relevance integer DEFAULT 0,
    region character varying,
    audio text[] DEFAULT '{}'::text[],
    subtitles text[] DEFAULT '{}'::text[],
    published boolean DEFAULT true,
    stale boolean DEFAULT false,
    category app.category,
    tags text[] DEFAULT '{}'::text[],
    video jsonb,
    source app.source DEFAULT 'api'::app.source,
    pace app.pace,
    certificate jsonb DEFAULT '{}'::jsonb,
    pricing_models jsonb DEFAULT '[]'::jsonb,
    offered_by jsonb DEFAULT '[]'::jsonb,
    syllabus text,
    effort integer,
    enrollments_count integer DEFAULT 0,
    free_content boolean DEFAULT false,
    paid_content boolean DEFAULT true,
    level app.level[] DEFAULT '{}'::app.level[],
    __provider_name__ character varying,
    __source_schema__ jsonb,
    __indexed_json__ jsonb,
    instructors jsonb DEFAULT '[]'::jsonb,
    curated_tags character varying[] DEFAULT '{}'::character varying[],
    refinement_tags character varying[],
    provider_id uuid,
    provider_crawler_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    expired_at timestamp with time zone DEFAULT (now() + '00:20:00'::interval) NOT NULL,
    old_provider_id bigint
);


--
-- Name: preview_courses; Type: VIEW; Schema: api; Owner: -
--

CREATE VIEW api.preview_courses AS
 SELECT course.id,
    course.status,
    course.name,
    course.description,
    course.slug,
    course.url,
    course.url_md5,
    course.duration_in_hours,
    course.price,
    course.rating,
    course.relevance,
    course.region,
    course.audio,
    course.subtitles,
    course.published,
    course.stale,
    course.category,
    course.tags,
    course.video,
    course.source,
    course.pace,
    course.certificate,
    course.pricing_models,
    course.offered_by,
    course.syllabus,
    course.effort,
    course.enrollments_count,
    course.free_content,
    course.paid_content,
    course.level,
    course.__provider_name__,
    course.__source_schema__,
    course.__indexed_json__,
    course.instructors,
    course.curated_tags,
    course.refinement_tags,
    course.provider_id,
    course.provider_crawler_id,
    course.created_at,
    course.updated_at,
    course.expired_at,
    course.old_provider_id
   FROM app.preview_courses course
  WHERE (((CURRENT_USER = 'user'::name) AND (EXISTS ( SELECT 1
           FROM app.provider_crawlers crawler
          WHERE ((crawler.status <> 'deleted'::app.crawler_status) AND (course.provider_crawler_id = crawler.id) AND public.if_user_by_ids(crawler.user_account_ids, true))))) OR (CURRENT_USER = 'admin'::name));


--
-- Name: preview_course_images; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.preview_course_images (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    kind character varying,
    file character varying,
    preview_course_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: preview_course_images; Type: VIEW; Schema: api; Owner: -
--

CREATE VIEW api.preview_course_images AS
 SELECT preview_course_images.id,
    preview_course_images.kind,
    preview_course_images.file,
    preview_course_images.preview_course_id,
    preview_course_images.created_at,
    preview_course_images.updated_at
   FROM (app.preview_course_images
     JOIN api.preview_courses ON ((preview_courses.id = preview_course_images.preview_course_id)));


--
-- Name: profiles; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.profiles (
    name character varying,
    date_of_birth date,
    oauth_avatar_url character varying,
    user_account_id bigint,
    interests text[] DEFAULT '{}'::text[],
    preferences jsonb DEFAULT '{}'::jsonb,
    _username character varying,
    uploaded_avatar_url character varying,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    username app.username,
    username_changed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    instructor boolean DEFAULT false,
    long_bio character varying,
    public boolean DEFAULT true,
    short_bio character varying,
    public_profiles jsonb DEFAULT '{}'::jsonb,
    teaching_subjects character varying[] DEFAULT '{}'::character varying[],
    social_profiles jsonb DEFAULT '{}'::jsonb,
    elearning_profiles jsonb DEFAULT '{}'::jsonb,
    country app.iso3166_1_alpha2_code,
    website character varying,
    course_ids uuid[] DEFAULT '{}'::uuid[],
    _name character varying,
    CONSTRAINT short_bio__length CHECK ((length((short_bio)::text) <= 60)),
    CONSTRAINT username__format CHECK (((_username)::text ~* '^\w{5,15}$'::text))
);


--
-- Name: profiles; Type: VIEW; Schema: api; Owner: -
--

CREATE VIEW api.profiles AS
 SELECT profiles.id,
    profiles.name,
    profiles.username,
    COALESCE(public.if_admin(profiles.short_bio), public.if_user_by_id(profiles.user_account_id, profiles.short_bio)) AS short_bio,
    COALESCE(public.if_admin(profiles.long_bio), public.if_user_by_id(profiles.user_account_id, profiles.long_bio)) AS long_bio,
    COALESCE(public.if_admin(profiles.instructor), public.if_user_by_id(profiles.user_account_id, profiles.instructor)) AS instructor,
    COALESCE(public.if_admin(profiles.public), public.if_user_by_id(profiles.user_account_id, profiles.public)) AS public,
    COALESCE(public.if_admin(profiles.country), public.if_user_by_id(profiles.user_account_id, profiles.country)) AS country,
    COALESCE(public.if_admin(profiles.website), public.if_user_by_id(profiles.user_account_id, profiles.website)) AS website,
    COALESCE(profiles.uploaded_avatar_url, profiles.oauth_avatar_url) AS avatar_url,
    COALESCE(public.if_admin(profiles.date_of_birth), public.if_user_by_id(profiles.user_account_id, profiles.date_of_birth)) AS date_of_birth,
    profiles.user_account_id,
    COALESCE(public.if_admin(profiles.interests), public.if_user_by_id(profiles.user_account_id, profiles.interests)) AS interests,
    COALESCE(public.if_admin(profiles.preferences), public.if_user_by_id(profiles.user_account_id, profiles.preferences)) AS preferences,
    COALESCE(public.if_admin(profiles.social_profiles), public.if_user_by_id(profiles.user_account_id, profiles.social_profiles)) AS social_profiles,
    COALESCE(public.if_admin(profiles.elearning_profiles), public.if_user_by_id(profiles.user_account_id, profiles.elearning_profiles)) AS elearning_profiles,
    COALESCE(public.if_admin(profiles.course_ids), public.if_user_by_id(profiles.user_account_id, profiles.course_ids)) AS course_ids
   FROM app.profiles;


--
-- Name: promo_accounts; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.promo_accounts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_account_id bigint,
    certificate_id uuid,
    price numeric(6,2) NOT NULL,
    purchase_date date NOT NULL,
    order_id character varying NOT NULL,
    paypal_account character varying NOT NULL,
    state character varying DEFAULT 'initial'::character varying NOT NULL,
    state_info character varying,
    old_self json DEFAULT '{}'::json NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT paypal_account__email CHECK (((paypal_account)::text ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'::text)),
    CONSTRAINT price__greater_than CHECK ((price >= (0)::numeric)),
    CONSTRAINT price__less_than CHECK ((price <= (5000)::numeric)),
    CONSTRAINT purchase_date__less_than CHECK ((purchase_date < now())),
    CONSTRAINT state__inclusion CHECK (((state)::text = ANY (ARRAY[('initial'::character varying)::text, ('pending'::character varying)::text, ('locked'::character varying)::text, ('rejected'::character varying)::text, ('approved'::character varying)::text])))
);


--
-- Name: promo_accounts; Type: VIEW; Schema: api; Owner: -
--

CREATE VIEW api.promo_accounts AS
 SELECT promo_accounts.id,
    COALESCE(public.if_admin(promo_accounts.user_account_id), public.if_user_by_id(promo_accounts.user_account_id, promo_accounts.user_account_id)) AS user_account_id,
    COALESCE(public.if_admin(promo_accounts.certificate_id), public.if_user_by_id(promo_accounts.user_account_id, promo_accounts.certificate_id)) AS certificate_id,
    COALESCE(public.if_admin(promo_accounts.price), public.if_user_by_id(promo_accounts.user_account_id, promo_accounts.price)) AS price,
    COALESCE(public.if_admin(promo_accounts.purchase_date), public.if_user_by_id(promo_accounts.user_account_id, promo_accounts.purchase_date)) AS purchase_date,
    COALESCE(public.if_admin(promo_accounts.order_id), public.if_user_by_id(promo_accounts.user_account_id, promo_accounts.order_id)) AS order_id,
    COALESCE(public.if_admin(promo_accounts.paypal_account), public.if_user_by_id(promo_accounts.user_account_id, promo_accounts.paypal_account)) AS paypal_account,
    COALESCE(public.if_admin(promo_accounts.state), public.if_user_by_id(promo_accounts.user_account_id, promo_accounts.state)) AS state,
    COALESCE(public.if_admin(promo_accounts.state_info), public.if_user_by_id(promo_accounts.user_account_id, promo_accounts.state_info)) AS state_info,
    COALESCE(public.if_admin(certificates.file), public.if_user_by_id(promo_accounts.user_account_id, certificates.file)) AS file,
    promo_accounts.created_at,
    promo_accounts.updated_at
   FROM (app.promo_accounts
     JOIN app.certificates ON ((promo_accounts.certificate_id = certificates.id)));


--
-- Name: provider_crawlers; Type: VIEW; Schema: api; Owner: -
--

CREATE VIEW api.provider_crawlers AS
 SELECT provider_crawlers.id,
    provider_crawlers.user_agent_token,
    provider_crawlers.provider_id,
    provider_crawlers.published,
    provider_crawlers.scheduled,
    provider_crawlers.created_at,
    provider_crawlers.updated_at,
    provider_crawlers.status,
    provider_crawlers.user_account_ids,
    provider_crawlers.sitemaps,
    provider_crawlers.version,
    provider_crawlers.settings,
    provider_crawlers.urls,
    provider_crawlers.old_provider_id
   FROM app.provider_crawlers
  WHERE (((provider_crawlers.status <> 'deleted'::app.crawler_status) AND public.if_user_by_ids(provider_crawlers.user_account_ids, true)) OR (CURRENT_USER = 'admin'::name));


--
-- Name: direct_uploads; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.direct_uploads (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_account_id bigint,
    file character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT valid_file_format CHECK ((lower((file)::text) ~ '.(gif|jpg|jpeg|png|pdf|svg)$'::text))
);


--
-- Name: provider_logos; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.provider_logos (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    direct_upload_id uuid NOT NULL,
    provider_id uuid NOT NULL,
    old_provider_id bigint
);


--
-- Name: provider_logos; Type: VIEW; Schema: api; Owner: -
--

CREATE VIEW api.provider_logos AS
 SELECT provider_logos.id,
    provider_logos.provider_id,
    direct_uploads.file,
    direct_uploads.user_account_id,
    direct_uploads.created_at,
    direct_uploads.updated_at,
    app.sign_direct_s3_fetch(direct_uploads.id, direct_uploads.file, (('provider_logos/'::text || ((provider_logos.provider_id)::character varying)::text))::character varying, 3600) AS fetch_url,
    app.sign_direct_s3_upload(direct_uploads.id, direct_uploads.file, (('provider_logos/'::text || ((provider_logos.provider_id)::character varying)::text))::character varying, 3600) AS upload_url,
    app.content_type_by_extension(direct_uploads.file) AS file_content_type
   FROM (app.provider_logos
     JOIN app.direct_uploads ON ((direct_uploads.id = provider_logos.direct_upload_id)))
  WHERE ((CURRENT_USER = 'admin'::name) OR ((CURRENT_USER = 'user'::name) AND ((current_setting('request.jwt.claim.sub'::text, true))::bigint = direct_uploads.user_account_id)));


--
-- Name: providers; Type: VIEW; Schema: api; Owner: -
--

CREATE VIEW api.providers AS
 SELECT provider.id,
    provider.name,
    provider.description,
    provider.slug,
    provider.afn_url_template,
    provider.published,
    provider.published_at,
    provider.created_at,
    provider.updated_at,
    provider.encoded_deep_linking,
    provider.name_dirty,
    provider.name_changed_at,
    provider.url,
    provider.old_id,
    provider.ignore_robots_noindex_rule_for,
    provider.ignore_robots_noindex_rule
   FROM app.providers provider
  WHERE (((CURRENT_USER = 'user'::name) AND (EXISTS ( SELECT 1
           FROM app.provider_crawlers crawler
          WHERE ((crawler.status <> 'deleted'::app.crawler_status) AND (crawler.provider_id = provider.id) AND public.if_user_by_ids(crawler.user_account_ids, true))))) OR (CURRENT_USER = 'admin'::name));


--
-- Name: user_accounts; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.user_accounts (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp with time zone,
    remember_created_at timestamp with time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    tracking_data json DEFAULT '{}'::json NOT NULL,
    confirmation_token character varying,
    confirmed_at timestamp with time zone,
    confirmation_sent_at timestamp with time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp with time zone,
    destroyed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    autogen_email_for_oauth boolean DEFAULT false NOT NULL
);


--
-- Name: user_accounts; Type: VIEW; Schema: api; Owner: -
--

CREATE VIEW api.user_accounts AS
 SELECT user_accounts.id,
    user_accounts.email,
    NULL::character varying AS password,
    COALESCE(public.if_admin(user_accounts.reset_password_token), public.if_user_by_id(user_accounts.id, user_accounts.reset_password_token)) AS reset_password_token,
    COALESCE(public.if_admin(user_accounts.reset_password_sent_at), public.if_user_by_id(user_accounts.id, user_accounts.reset_password_sent_at)) AS reset_password_sent_at,
    COALESCE(public.if_admin(user_accounts.remember_created_at), public.if_user_by_id(user_accounts.id, user_accounts.remember_created_at)) AS remember_created_at,
    COALESCE(public.if_admin(user_accounts.sign_in_count), public.if_user_by_id(user_accounts.id, user_accounts.sign_in_count)) AS sign_in_count,
    COALESCE(public.if_admin(user_accounts.current_sign_in_at), public.if_user_by_id(user_accounts.id, user_accounts.current_sign_in_at)) AS current_sign_in_at,
    COALESCE(public.if_admin(user_accounts.last_sign_in_at), public.if_user_by_id(user_accounts.id, user_accounts.last_sign_in_at)) AS last_sign_in_at,
    COALESCE(public.if_admin(user_accounts.current_sign_in_ip), public.if_user_by_id(user_accounts.id, user_accounts.current_sign_in_ip)) AS current_sign_in_ip,
    COALESCE(public.if_admin(user_accounts.last_sign_in_ip), public.if_user_by_id(user_accounts.id, user_accounts.last_sign_in_ip)) AS last_sign_in_ip,
    COALESCE(public.if_admin(user_accounts.tracking_data), public.if_user_by_id(user_accounts.id, user_accounts.tracking_data)) AS tracking_data,
    COALESCE(public.if_admin(user_accounts.confirmation_token), public.if_user_by_id(user_accounts.id, user_accounts.confirmation_token)) AS confirmation_token,
    COALESCE(public.if_admin(user_accounts.confirmed_at), public.if_user_by_id(user_accounts.id, user_accounts.confirmed_at)) AS confirmed_at,
    COALESCE(public.if_admin(user_accounts.confirmation_sent_at), public.if_user_by_id(user_accounts.id, user_accounts.confirmation_sent_at)) AS confirmation_sent_at,
    COALESCE(public.if_admin(user_accounts.unconfirmed_email), public.if_user_by_id(user_accounts.id, user_accounts.unconfirmed_email)) AS unconfirmed_email,
    COALESCE(public.if_admin(user_accounts.failed_attempts), public.if_user_by_id(user_accounts.id, user_accounts.failed_attempts)) AS failed_attempts,
    COALESCE(public.if_admin(user_accounts.unlock_token), public.if_user_by_id(user_accounts.id, user_accounts.unlock_token)) AS unlock_token,
    COALESCE(public.if_admin(user_accounts.locked_at), public.if_user_by_id(user_accounts.id, user_accounts.locked_at)) AS locked_at,
    COALESCE(public.if_admin(user_accounts.destroyed_at), public.if_user_by_id(user_accounts.id, user_accounts.destroyed_at)) AS destroyed_at,
    COALESCE(public.if_admin(user_accounts.autogen_email_for_oauth), public.if_user_by_id(user_accounts.id, user_accounts.autogen_email_for_oauth)) AS autogen_email_for_oauth,
    user_accounts.created_at,
    user_accounts.updated_at
   FROM app.user_accounts;


--
-- Name: admin_accounts_id_seq; Type: SEQUENCE; Schema: app; Owner: -
--

CREATE SEQUENCE app.admin_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: app; Owner: -
--

ALTER SEQUENCE app.admin_accounts_id_seq OWNED BY app.admin_accounts.id;


--
-- Name: admin_profiles; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.admin_profiles (
    name character varying,
    bio text,
    preferences jsonb,
    admin_account_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


--
-- Name: contacts; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.contacts (
    id bigint NOT NULL,
    name character varying,
    email character varying,
    subject character varying,
    message text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    reason app.contact_reason
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: app; Owner: -
--

CREATE SEQUENCE app.contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: app; Owner: -
--

ALTER SEQUENCE app.contacts_id_seq OWNED BY app.contacts.id;


--
-- Name: course_reviews; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.course_reviews (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_account_id bigint,
    tracked_action_id uuid,
    rating numeric(1,0),
    completed boolean,
    feedback character varying,
    state character varying DEFAULT 'pending'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT rating__greater_than CHECK ((rating >= (1)::numeric)),
    CONSTRAINT rating__less_than CHECK ((rating <= (5)::numeric)),
    CONSTRAINT state__inclusion CHECK (((state)::text = ANY (ARRAY[('pending'::character varying)::text, ('accessed'::character varying)::text, ('submitted'::character varying)::text])))
);


--
-- Name: curated_tags_versions; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.curated_tags_versions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    course_id uuid,
    curated_tags character varying[] DEFAULT '{}'::character varying[],
    excluded_tags character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    current boolean DEFAULT false,
    author character varying
);


--
-- Name: favorites; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.favorites (
    id bigint NOT NULL,
    user_account_id bigint,
    course_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: favorites_id_seq; Type: SEQUENCE; Schema: app; Owner: -
--

CREATE SEQUENCE app.favorites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: app; Owner: -
--

ALTER SEQUENCE app.favorites_id_seq OWNED BY app.favorites.id;


--
-- Name: images; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.images (
    id bigint NOT NULL,
    caption character varying,
    file character varying,
    pos integer DEFAULT 0,
    imageable_type character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    imageable_id uuid
);


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: app; Owner: -
--

CREATE SEQUENCE app.images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: app; Owner: -
--

ALTER SEQUENCE app.images_id_seq OWNED BY app.images.id;


--
-- Name: landing_pages; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.landing_pages (
    id bigint NOT NULL,
    slug public.citext,
    template character varying,
    meta_html text,
    html jsonb DEFAULT '{}'::jsonb,
    body_html text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    data jsonb DEFAULT '{}'::jsonb,
    erb_template text,
    layout character varying
);


--
-- Name: landing_pages_id_seq; Type: SEQUENCE; Schema: app; Owner: -
--

CREATE SEQUENCE app.landing_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: landing_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: app; Owner: -
--

ALTER SEQUENCE app.landing_pages_id_seq OWNED BY app.landing_pages.id;


--
-- Name: napoleon_course_mapping; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.napoleon_course_mapping (
    old_resource_id uuid NOT NULL,
    resource_id uuid
);


--
-- Name: oauth_accounts; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.oauth_accounts (
    id bigint NOT NULL,
    provider character varying,
    uid character varying,
    raw_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    user_account_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: oauth_accounts_id_seq; Type: SEQUENCE; Schema: app; Owner: -
--

CREATE SEQUENCE app.oauth_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: app; Owner: -
--

ALTER SEQUENCE app.oauth_accounts_id_seq OWNED BY app.oauth_accounts.id;


--
-- Name: orphaned_profiles; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.orphaned_profiles (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_account_id bigint,
    name character varying(75) NOT NULL,
    country character varying(3),
    short_bio character varying(200),
    long_bio text,
    email character varying(320),
    website character varying,
    avatar_url character varying,
    public_profiles jsonb DEFAULT '{}'::jsonb,
    languages character varying[] DEFAULT '{}'::character varying[],
    course_ids uuid[] DEFAULT '{}'::uuid[],
    state character varying(20) DEFAULT 'disabled'::character varying,
    slug character varying,
    claimable_emails character varying[] DEFAULT '{}'::character varying[],
    claimable_public_profiles jsonb DEFAULT '{}'::jsonb,
    claim_code character varying(64),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    claim_code_expires_at timestamp with time zone,
    claimed_at timestamp with time zone,
    claimed_by character varying,
    marked_as_destroyed_at timestamp with time zone,
    teaching_subjects character varying[] DEFAULT '{}'::character varying[],
    teaching_at character varying[] DEFAULT '{}'::character varying[],
    ignore_robots_noindex_rule_for app.locale[] DEFAULT '{}'::app.locale[],
    ignore_robots_noindex_rule boolean DEFAULT false,
    CONSTRAINT state__inclusion CHECK (((state)::text = ANY (ARRAY[('disabled'::character varying)::text, ('enabled'::character varying)::text])))
);


--
-- Name: post_relations; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.post_relations (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    relation_type character varying NOT NULL,
    relation_id uuid NOT NULL,
    post_id uuid
);


--
-- Name: posts; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.posts (
    slug character varying,
    title character varying,
    body text,
    tags character varying[] DEFAULT '{}'::character varying[],
    meta jsonb DEFAULT '"{\"title\": \"\", \"description\": \"\"}"'::jsonb,
    locale app.iso639_code DEFAULT 'en'::app.iso639_code,
    status app.post_status DEFAULT 'draft'::app.post_status,
    content_fingerprint character varying,
    published_at timestamp with time zone,
    content_changed_at timestamp with time zone,
    admin_account_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    use_cover_image boolean DEFAULT false,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    original_post_id uuid
);


--
-- Name: promo_account_logs; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.promo_account_logs (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    promo_account_id uuid,
    old jsonb DEFAULT '{}'::jsonb,
    new jsonb DEFAULT '{}'::jsonb,
    role character varying NOT NULL
);


--
-- Name: provider_pricings; Type: MATERIALIZED VIEW; Schema: app; Owner: -
--

CREATE MATERIALIZED VIEW app.provider_pricings AS
 SELECT sq2.provider_id,
    array_agg(DISTINCT sq2.type) AS membership_types,
    min(app.price_in_decimal(sq2.price)) AS min_price,
    max(app.price_in_decimal(sq2.price)) AS max_price,
    min(app.price_in_decimal(sq2.trial_price)) AS min_trial_price,
    max(app.price_in_decimal(sq2.trial_price)) AS max_trial_price
   FROM ( SELECT DISTINCT ON (sq.id) sq.provider_id,
            unnest(array_agg(DISTINCT sq.type)) AS type,
            min(
                CASE
                    WHEN (sq.type = 'single_course'::text) THEN sq.price
                    ELSE sq.total_price
                END) AS price,
            min(sq.trial_price) AS trial_price
           FROM ( SELECT courses.id,
                    courses.provider_id,
                    (jsonb_array_elements(courses.pricing_models) ->> 'type'::text) AS type,
                    (jsonb_array_elements(courses.pricing_models) ->> 'price'::text) AS price,
                    (jsonb_array_elements(courses.pricing_models) ->> 'total_price'::text) AS total_price,
                    ((jsonb_array_elements(courses.pricing_models) -> 'trial_period'::text) ->> 'value'::text) AS trial_price,
                    app.currency_index(((jsonb_array_elements(courses.pricing_models) ->> ('currency'::character varying)::text))::character varying) AS currency
                   FROM app.courses
                  WHERE (courses.published = true)) sq
          GROUP BY sq.id, sq.provider_id, sq.currency) sq2
  GROUP BY sq2.provider_id
  WITH NO DATA;


--
-- Name: provider_stats; Type: MATERIALIZED VIEW; Schema: app; Owner: -
--

CREATE MATERIALIZED VIEW app.provider_stats AS
 WITH top_countries AS (
         SELECT sq.provider_id,
            (array_agg(sq.country))[1:5] AS countries
           FROM ( SELECT enrollments.provider_id,
                    (enrollments.tracking_data ->> 'country'::text) AS country,
                    count(*) AS count_all
                   FROM app.enrollments
                  WHERE ((enrollments.tracking_data ->> 'country'::text) IS NOT NULL)
                  GROUP BY enrollments.provider_id, (enrollments.tracking_data ->> 'country'::text)
                  ORDER BY (count(*)) DESC) sq
          GROUP BY sq.provider_id
        ), areas_of_knowledge AS (
         SELECT DISTINCT ON (sq.provider_id) sq.provider_id,
            sq.tag,
            count(*) AS count_all
           FROM ( SELECT courses.provider_id,
                    unnest(curated_tags_versions.curated_tags) AS tag
                   FROM (app.courses
                     JOIN app.curated_tags_versions ON ((curated_tags_versions.course_id = courses.id)))
                  WHERE ((courses.published = true) AND (curated_tags_versions.current = true))) sq
          WHERE ((sq.tag)::text = ANY ((ARRAY['computer_science'::character varying, 'arts_and_design'::character varying, 'business'::character varying, 'personal_development'::character varying, 'data_science'::character varying, 'physical_science_and_engineering'::character varying, 'marketing'::character varying, 'language_and_communication'::character varying, 'life_sciences'::character varying, 'math_and_logic'::character varying, 'social_sciences'::character varying, 'health_and_fitness'::character varying])::text[]))
          GROUP BY sq.provider_id, sq.tag
          ORDER BY sq.provider_id, (count(*)) DESC
        ), indexed_courses AS (
         SELECT courses.provider_id,
            count(*) AS count_all
           FROM app.courses
          WHERE (courses.published = true)
          GROUP BY courses.provider_id
        ), instructors AS (
         SELECT ( SELECT providers_1.id
                   FROM app.providers providers_1
                  WHERE ((providers_1.name)::text = (sq.teaching_at)::text)) AS provider_id,
            count(*) AS count_all
           FROM ( SELECT orphaned_profiles.id,
                    unnest(orphaned_profiles.teaching_at) AS teaching_at
                   FROM app.orphaned_profiles
                  WHERE ((orphaned_profiles.state)::text = 'enabled'::text)) sq
          GROUP BY ( SELECT providers_1.id
                   FROM app.providers providers_1
                  WHERE ((providers_1.name)::text = (sq.teaching_at)::text))
        )
 SELECT providers.id AS provider_id,
    top_countries.countries AS top_countries,
    areas_of_knowledge.tag AS areas_of_knowledge,
    indexed_courses.count_all AS indexed_courses,
    instructors.count_all AS instructors
   FROM ((((app.providers
     LEFT JOIN top_countries ON ((top_countries.provider_id = providers.id)))
     LEFT JOIN areas_of_knowledge ON ((areas_of_knowledge.provider_id = providers.id)))
     LEFT JOIN indexed_courses ON ((indexed_courses.provider_id = providers.id)))
     LEFT JOIN instructors ON ((instructors.provider_id = providers.id)))
  WHERE ((top_countries.* IS NOT NULL) OR (areas_of_knowledge.* IS NOT NULL) OR (indexed_courses.* IS NOT NULL) OR (instructors.* IS NOT NULL))
  WITH NO DATA;


--
-- Name: providers_id_seq; Type: SEQUENCE; Schema: app; Owner: -
--

CREATE SEQUENCE app.providers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: providers_id_seq; Type: SEQUENCE OWNED BY; Schema: app; Owner: -
--

ALTER SEQUENCE app.providers_id_seq OWNED BY app.providers.id;


--
-- Name: slug_histories; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.slug_histories (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    course_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: subscriptions; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.subscriptions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    digest boolean DEFAULT true NOT NULL,
    newsletter boolean DEFAULT true NOT NULL,
    promotions boolean DEFAULT true NOT NULL,
    recommendations boolean DEFAULT true NOT NULL,
    reports boolean DEFAULT true NOT NULL,
    unsubscribe_reasons jsonb DEFAULT '{}'::jsonb,
    unsubscribed_at timestamp with time zone,
    profile_id uuid
);


--
-- Name: tracked_searches; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.tracked_searches (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    version character varying,
    action character varying,
    request jsonb,
    results jsonb,
    tracked_data jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: used_usernames; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.used_usernames (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    profile_id uuid NOT NULL,
    username app.username NOT NULL
);


--
-- Name: user_accounts_id_seq; Type: SEQUENCE; Schema: app; Owner: -
--

CREATE SEQUENCE app.user_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: app; Owner: -
--

ALTER SEQUENCE app.user_accounts_id_seq OWNED BY app.user_accounts.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: que_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.que_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: que_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.que_jobs_id_seq OWNED BY public.que_jobs.id;


--
-- Name: que_lockers; Type: TABLE; Schema: public; Owner: -
--

CREATE UNLOGGED TABLE public.que_lockers (
    pid integer NOT NULL,
    worker_count integer NOT NULL,
    worker_priorities integer[] NOT NULL,
    ruby_pid integer NOT NULL,
    ruby_hostname text NOT NULL,
    queues text[] NOT NULL,
    listening boolean NOT NULL,
    CONSTRAINT valid_queues CHECK (((array_ndims(queues) = 1) AND (array_length(queues, 1) IS NOT NULL))),
    CONSTRAINT valid_worker_priorities CHECK (((array_ndims(worker_priorities) = 1) AND (array_length(worker_priorities, 1) IS NOT NULL)))
);


--
-- Name: que_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.que_values (
    key text NOT NULL,
    value jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT valid_value CHECK ((jsonb_typeof(value) = 'object'::text))
)
WITH (fillfactor='90');


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: admin_accounts id; Type: DEFAULT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.admin_accounts ALTER COLUMN id SET DEFAULT nextval('app.admin_accounts_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.contacts ALTER COLUMN id SET DEFAULT nextval('app.contacts_id_seq'::regclass);


--
-- Name: favorites id; Type: DEFAULT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.favorites ALTER COLUMN id SET DEFAULT nextval('app.favorites_id_seq'::regclass);


--
-- Name: images id; Type: DEFAULT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.images ALTER COLUMN id SET DEFAULT nextval('app.images_id_seq'::regclass);


--
-- Name: landing_pages id; Type: DEFAULT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.landing_pages ALTER COLUMN id SET DEFAULT nextval('app.landing_pages_id_seq'::regclass);


--
-- Name: oauth_accounts id; Type: DEFAULT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.oauth_accounts ALTER COLUMN id SET DEFAULT nextval('app.oauth_accounts_id_seq'::regclass);


--
-- Name: user_accounts id; Type: DEFAULT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.user_accounts ALTER COLUMN id SET DEFAULT nextval('app.user_accounts_id_seq'::regclass);


--
-- Name: que_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_jobs ALTER COLUMN id SET DEFAULT nextval('public.que_jobs_id_seq'::regclass);


--
-- Name: admin_accounts admin_accounts_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.admin_accounts
    ADD CONSTRAINT admin_accounts_pkey PRIMARY KEY (id);


--
-- Name: admin_profiles admin_profiles_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.admin_profiles
    ADD CONSTRAINT admin_profiles_pkey PRIMARY KEY (id);


--
-- Name: certificates certificates_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.certificates
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);


--
-- Name: promo_accounts cntr_promo_accounts_user_account_id; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.promo_accounts
    ADD CONSTRAINT cntr_promo_accounts_user_account_id UNIQUE (user_account_id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: course_reviews course_reviews_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.course_reviews
    ADD CONSTRAINT course_reviews_pkey PRIMARY KEY (id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: crawler_domains crawler_domains_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.crawler_domains
    ADD CONSTRAINT crawler_domains_pkey PRIMARY KEY (id);


--
-- Name: crawling_events crawling_events_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.crawling_events
    ADD CONSTRAINT crawling_events_pkey PRIMARY KEY (id);


--
-- Name: curated_tags_versions curated_tags_versions_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.curated_tags_versions
    ADD CONSTRAINT curated_tags_versions_pkey PRIMARY KEY (id);


--
-- Name: direct_uploads direct_uploads_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.direct_uploads
    ADD CONSTRAINT direct_uploads_pkey PRIMARY KEY (id);


--
-- Name: enrollments enrollments_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.enrollments
    ADD CONSTRAINT enrollments_pkey PRIMARY KEY (id);


--
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (id);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: landing_pages landing_pages_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.landing_pages
    ADD CONSTRAINT landing_pages_pkey PRIMARY KEY (id);


--
-- Name: napoleon_course_mapping napoleon_course_mapping_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.napoleon_course_mapping
    ADD CONSTRAINT napoleon_course_mapping_pkey PRIMARY KEY (old_resource_id);


--
-- Name: oauth_accounts oauth_accounts_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.oauth_accounts
    ADD CONSTRAINT oauth_accounts_pkey PRIMARY KEY (id);


--
-- Name: orphaned_profiles orphaned_profiles_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.orphaned_profiles
    ADD CONSTRAINT orphaned_profiles_pkey PRIMARY KEY (id);


--
-- Name: post_relations post_relations_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.post_relations
    ADD CONSTRAINT post_relations_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: preview_course_images preview_course_images_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.preview_course_images
    ADD CONSTRAINT preview_course_images_pkey PRIMARY KEY (id);


--
-- Name: preview_courses preview_courses_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.preview_courses
    ADD CONSTRAINT preview_courses_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: promo_account_logs promo_account_logs_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.promo_account_logs
    ADD CONSTRAINT promo_account_logs_pkey PRIMARY KEY (id);


--
-- Name: promo_accounts promo_accounts_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.promo_accounts
    ADD CONSTRAINT promo_accounts_pkey PRIMARY KEY (id);


--
-- Name: provider_crawlers provider_crawlers_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.provider_crawlers
    ADD CONSTRAINT provider_crawlers_pkey PRIMARY KEY (id);


--
-- Name: provider_logos provider_logos_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.provider_logos
    ADD CONSTRAINT provider_logos_pkey PRIMARY KEY (id);


--
-- Name: providers providers_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.providers
    ADD CONSTRAINT providers_pkey PRIMARY KEY (id);


--
-- Name: slug_histories slug_histories_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.slug_histories
    ADD CONSTRAINT slug_histories_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: tracked_actions tracked_actions_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.tracked_actions
    ADD CONSTRAINT tracked_actions_pkey PRIMARY KEY (id);


--
-- Name: tracked_searches tracked_searches_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.tracked_searches
    ADD CONSTRAINT tracked_searches_pkey PRIMARY KEY (id);


--
-- Name: used_usernames used_usernames_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.used_usernames
    ADD CONSTRAINT used_usernames_pkey PRIMARY KEY (id);


--
-- Name: user_accounts user_accounts_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.user_accounts
    ADD CONSTRAINT user_accounts_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: que_jobs que_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_jobs
    ADD CONSTRAINT que_jobs_pkey PRIMARY KEY (id);


--
-- Name: que_lockers que_lockers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_lockers
    ADD CONSTRAINT que_lockers_pkey PRIMARY KEY (pid);


--
-- Name: que_values que_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_values
    ADD CONSTRAINT que_values_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: app_crawler_domains_unique_domain_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX app_crawler_domains_unique_domain_idx ON app.crawler_domains USING btree (domain);


--
-- Name: index_admin_accounts_on_confirmation_token; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_admin_accounts_on_confirmation_token ON app.admin_accounts USING btree (confirmation_token);


--
-- Name: index_admin_accounts_on_email; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_admin_accounts_on_email ON app.admin_accounts USING btree (email);


--
-- Name: index_admin_accounts_on_reset_password_token; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_admin_accounts_on_reset_password_token ON app.admin_accounts USING btree (reset_password_token);


--
-- Name: index_admin_accounts_on_unlock_token; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_admin_accounts_on_unlock_token ON app.admin_accounts USING btree (unlock_token);


--
-- Name: index_admin_profiles_on_admin_account_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_admin_profiles_on_admin_account_id ON app.admin_profiles USING btree (admin_account_id);


--
-- Name: index_course_reviews_on_user_account_id_and_tracked_action_id; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_course_reviews_on_user_account_id_and_tracked_action_id ON app.course_reviews USING btree (user_account_id, tracked_action_id);


--
-- Name: index_courses_on_dataset_sequence; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_courses_on_dataset_sequence ON app.courses USING btree (dataset_sequence);


--
-- Name: index_courses_on_global_sequence; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_courses_on_global_sequence ON app.courses USING btree (global_sequence);


--
-- Name: index_courses_on_provider_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_courses_on_provider_id ON app.courses USING btree (provider_id);


--
-- Name: index_courses_on_provider_id_published; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_courses_on_provider_id_published ON app.courses USING btree (provider_id) WHERE (published = true);


--
-- Name: index_courses_on_slug; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_courses_on_slug ON app.courses USING btree (slug) WHERE (published = true);


--
-- Name: index_courses_on_tags; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_courses_on_tags ON app.courses USING gin (tags);


--
-- Name: index_courses_on_up_to_date_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_courses_on_up_to_date_id ON app.courses USING btree (up_to_date_id);


--
-- Name: index_courses_on_url; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_courses_on_url ON app.courses USING btree (url) WHERE (published = true);


--
-- Name: index_curated_tags_versions_on_course_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_curated_tags_versions_on_course_id ON app.curated_tags_versions USING btree (course_id);


--
-- Name: index_curated_tags_versions_on_curated_tags; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_curated_tags_versions_on_curated_tags ON app.curated_tags_versions USING gin (curated_tags);


--
-- Name: index_enrollments_on_course_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_enrollments_on_course_id ON app.enrollments USING btree (course_id);


--
-- Name: index_enrollments_on_provider_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_enrollments_on_provider_id ON app.enrollments USING btree (provider_id);


--
-- Name: index_enrollments_on_tracked_search_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_enrollments_on_tracked_search_id ON app.enrollments USING btree (tracked_search_id);


--
-- Name: index_enrollments_on_tracking_data; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_enrollments_on_tracking_data ON app.enrollments USING gin (tracking_data);


--
-- Name: index_enrollments_on_user_account_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_enrollments_on_user_account_id ON app.enrollments USING btree (user_account_id);


--
-- Name: index_favorites_on_course_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_favorites_on_course_id ON app.favorites USING btree (course_id);


--
-- Name: index_favorites_on_user_account_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_favorites_on_user_account_id ON app.favorites USING btree (user_account_id);


--
-- Name: index_images_on_imageable_type_and_imageable_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_images_on_imageable_type_and_imageable_id ON app.images USING btree (imageable_type, imageable_id);


--
-- Name: index_landing_pages_on_slug; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_landing_pages_on_slug ON app.landing_pages USING btree (slug);


--
-- Name: index_oauth_accounts_on_user_account_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_oauth_accounts_on_user_account_id ON app.oauth_accounts USING btree (user_account_id);


--
-- Name: index_orphaned_profiles_on_name; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_orphaned_profiles_on_name ON app.orphaned_profiles USING btree (name);


--
-- Name: index_orphaned_profiles_on_user_account_id; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_orphaned_profiles_on_user_account_id ON app.orphaned_profiles USING btree (user_account_id);


--
-- Name: index_post_relations_on_post_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_post_relations_on_post_id ON app.post_relations USING btree (post_id);


--
-- Name: index_post_relations_on_relation_fields; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_post_relations_on_relation_fields ON app.post_relations USING btree (relation_id, relation_type);


--
-- Name: index_post_relations_unique; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_post_relations_unique ON app.post_relations USING btree (relation_id, relation_type, post_id);


--
-- Name: index_posts_on_admin_account_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_posts_on_admin_account_id ON app.posts USING btree (admin_account_id);


--
-- Name: index_posts_on_original_post_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_posts_on_original_post_id ON app.posts USING btree (original_post_id);


--
-- Name: index_posts_on_slug; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_posts_on_slug ON app.posts USING btree (slug);


--
-- Name: index_posts_on_tags; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_posts_on_tags ON app.posts USING gin (tags);


--
-- Name: index_profiles_on_user_account_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_profiles_on_user_account_id ON app.profiles USING btree (user_account_id);


--
-- Name: index_profiles_on_username; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_profiles_on_username ON app.profiles USING btree (_username);


--
-- Name: index_promo_accounts_on_user_account_id; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_promo_accounts_on_user_account_id ON app.promo_accounts USING btree (user_account_id);


--
-- Name: index_provider_logos_on_direct_upload_id; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_provider_logos_on_direct_upload_id ON app.provider_logos USING btree (direct_upload_id);


--
-- Name: index_provider_logos_on_provider_id; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_provider_logos_on_provider_id ON app.provider_logos USING btree (provider_id);


--
-- Name: index_providers_on_name; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_providers_on_name ON app.providers USING btree (name);


--
-- Name: index_providers_on_slug; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_providers_on_slug ON app.providers USING btree (slug);


--
-- Name: index_slug_histories_on_course_id_and_slug; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_slug_histories_on_course_id_and_slug ON app.slug_histories USING btree (course_id, slug);


--
-- Name: index_subscriptions_on_profiles_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_subscriptions_on_profiles_id ON app.subscriptions USING btree (profile_id);


--
-- Name: index_tracked_actions_on_compound_ext_id; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_tracked_actions_on_compound_ext_id ON app.tracked_actions USING btree (compound_ext_id);


--
-- Name: index_tracked_actions_on_enrollment_id; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_tracked_actions_on_enrollment_id ON app.tracked_actions USING btree (enrollment_id);


--
-- Name: index_tracked_actions_on_payload; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_tracked_actions_on_payload ON app.tracked_actions USING gin (payload);


--
-- Name: index_tracked_actions_on_status; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_tracked_actions_on_status ON app.tracked_actions USING btree (status);


--
-- Name: index_tracked_searches_on_action; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX index_tracked_searches_on_action ON app.tracked_searches USING btree (action);


--
-- Name: index_user_accounts_on_confirmation_token; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_user_accounts_on_confirmation_token ON app.user_accounts USING btree (confirmation_token);


--
-- Name: index_user_accounts_on_email; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_user_accounts_on_email ON app.user_accounts USING btree (email);


--
-- Name: index_user_accounts_on_reset_password_token; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_user_accounts_on_reset_password_token ON app.user_accounts USING btree (reset_password_token);


--
-- Name: index_user_accounts_on_unlock_token; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX index_user_accounts_on_unlock_token ON app.user_accounts USING btree (unlock_token);


--
-- Name: profiles_username_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX profiles_username_idx ON app.profiles USING btree (username);


--
-- Name: used_usernames_profile_id_username_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX used_usernames_profile_id_username_idx ON app.used_usernames USING btree (profile_id, username);


--
-- Name: used_usernames_username_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX used_usernames_username_idx ON app.used_usernames USING btree (username);


--
-- Name: que_jobs_args_gin_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX que_jobs_args_gin_idx ON public.que_jobs USING gin (args jsonb_path_ops);


--
-- Name: que_jobs_data_gin_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX que_jobs_data_gin_idx ON public.que_jobs USING gin (data jsonb_path_ops);


--
-- Name: que_poll_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX que_poll_idx ON public.que_jobs USING btree (queue, priority, run_at, id) WHERE ((finished_at IS NULL) AND (expired_at IS NULL));


--
-- Name: admin_accounts api_admin_accounts_view_instead; Type: TRIGGER; Schema: api; Owner: -
--

CREATE TRIGGER api_admin_accounts_view_instead INSTEAD OF INSERT OR UPDATE ON api.admin_accounts FOR EACH ROW EXECUTE PROCEDURE triggers.api_admin_accounts_view_instead();


--
-- Name: certificates api_certificates_view_instead; Type: TRIGGER; Schema: api; Owner: -
--

CREATE TRIGGER api_certificates_view_instead INSTEAD OF INSERT OR UPDATE ON api.certificates FOR EACH ROW EXECUTE PROCEDURE triggers.api_certificates_view_instead();


--
-- Name: crawler_domains api_crawler_domains_view_instead_of_delete; Type: TRIGGER; Schema: api; Owner: -
--

CREATE TRIGGER api_crawler_domains_view_instead_of_delete INSTEAD OF DELETE ON api.crawler_domains FOR EACH ROW EXECUTE PROCEDURE triggers.api_crawler_domains_view_instead_of_delete();


--
-- Name: crawler_domains api_crawler_domains_view_instead_of_insert; Type: TRIGGER; Schema: api; Owner: -
--

CREATE TRIGGER api_crawler_domains_view_instead_of_insert INSTEAD OF INSERT ON api.crawler_domains FOR EACH ROW EXECUTE PROCEDURE triggers.api_crawler_domains_view_instead_of_insert();


--
-- Name: crawler_domains api_crawler_domains_view_instead_of_update; Type: TRIGGER; Schema: api; Owner: -
--

CREATE TRIGGER api_crawler_domains_view_instead_of_update INSTEAD OF UPDATE ON api.crawler_domains FOR EACH ROW EXECUTE PROCEDURE triggers.api_crawler_domains_view_instead_of_update();


--
-- Name: preview_courses api_preview_courses_view_instead_of_insert; Type: TRIGGER; Schema: api; Owner: -
--

CREATE TRIGGER api_preview_courses_view_instead_of_insert INSTEAD OF INSERT OR UPDATE ON api.preview_courses FOR EACH ROW EXECUTE PROCEDURE triggers.api_preview_courses_view_instead_of_insert();


--
-- Name: profiles api_profiles_view_instead; Type: TRIGGER; Schema: api; Owner: -
--

CREATE TRIGGER api_profiles_view_instead INSTEAD OF UPDATE ON api.profiles FOR EACH ROW EXECUTE PROCEDURE triggers.api_profiles_view_instead();


--
-- Name: promo_accounts api_promo_accounts_view_instead; Type: TRIGGER; Schema: api; Owner: -
--

CREATE TRIGGER api_promo_accounts_view_instead INSTEAD OF INSERT OR UPDATE ON api.promo_accounts FOR EACH ROW EXECUTE PROCEDURE triggers.api_promo_accounts_view_instead();


--
-- Name: provider_crawlers api_provider_crawlers_view_instead_of_delete; Type: TRIGGER; Schema: api; Owner: -
--

CREATE TRIGGER api_provider_crawlers_view_instead_of_delete INSTEAD OF DELETE ON api.provider_crawlers FOR EACH ROW EXECUTE PROCEDURE triggers.api_provider_crawlers_view_instead_of_delete();


--
-- Name: provider_crawlers api_provider_crawlers_view_instead_of_insert; Type: TRIGGER; Schema: api; Owner: -
--

CREATE TRIGGER api_provider_crawlers_view_instead_of_insert INSTEAD OF INSERT ON api.provider_crawlers FOR EACH ROW EXECUTE PROCEDURE triggers.api_provider_crawlers_view_instead_of_insert();


--
-- Name: provider_crawlers api_provider_crawlers_view_instead_of_update; Type: TRIGGER; Schema: api; Owner: -
--

CREATE TRIGGER api_provider_crawlers_view_instead_of_update INSTEAD OF UPDATE ON api.provider_crawlers FOR EACH ROW EXECUTE PROCEDURE triggers.api_provider_crawlers_view_instead_of_update();


--
-- Name: provider_logos api_provider_logos_view_instead; Type: TRIGGER; Schema: api; Owner: -
--

CREATE TRIGGER api_provider_logos_view_instead INSTEAD OF INSERT OR UPDATE ON api.provider_logos FOR EACH ROW EXECUTE PROCEDURE triggers.api_provider_logos_view_instead();


--
-- Name: providers api_providers_view_instead_of_update; Type: TRIGGER; Schema: api; Owner: -
--

CREATE TRIGGER api_providers_view_instead_of_update INSTEAD OF UPDATE ON api.providers FOR EACH ROW EXECUTE PROCEDURE triggers.api_providers_view_instead_of_update();


--
-- Name: user_accounts api_user_accounts_view_instead; Type: TRIGGER; Schema: api; Owner: -
--

CREATE TRIGGER api_user_accounts_view_instead INSTEAD OF UPDATE ON api.user_accounts FOR EACH ROW EXECUTE PROCEDURE triggers.api_user_accounts_view_instead();


--
-- Name: enrollments check_course_provider_relationship; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER check_course_provider_relationship BEFORE INSERT OR UPDATE ON app.enrollments FOR EACH ROW EXECUTE PROCEDURE triggers.check_course_provider_relationship();


--
-- Name: courses course_keep_slug; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER course_keep_slug AFTER INSERT OR UPDATE ON app.courses FOR EACH ROW EXECUTE PROCEDURE triggers.course_keep_slug();


--
-- Name: courses course_normalize_languages; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER course_normalize_languages BEFORE INSERT OR UPDATE ON app.courses FOR EACH ROW EXECUTE PROCEDURE triggers.course_normalize_languages();


--
-- Name: preview_courses course_normalize_languages; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER course_normalize_languages BEFORE INSERT OR UPDATE ON app.preview_courses FOR EACH ROW EXECUTE PROCEDURE triggers.course_normalize_languages();


--
-- Name: profiles create_profiles_subscription; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER create_profiles_subscription AFTER INSERT ON app.profiles FOR EACH ROW EXECUTE PROCEDURE triggers.create_subscription();


--
-- Name: admin_accounts encrypt_password; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER encrypt_password BEFORE INSERT OR UPDATE ON app.admin_accounts FOR EACH ROW EXECUTE PROCEDURE triggers.encrypt_password();


--
-- Name: user_accounts encrypt_password; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER encrypt_password BEFORE INSERT OR UPDATE ON app.user_accounts FOR EACH ROW EXECUTE PROCEDURE triggers.encrypt_password();


--
-- Name: tracked_actions set_compound_ext_id; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER set_compound_ext_id BEFORE INSERT ON app.tracked_actions FOR EACH ROW EXECUTE PROCEDURE triggers.gen_compound_ext_id();


--
-- Name: courses sort_prices; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER sort_prices BEFORE INSERT OR UPDATE ON app.courses FOR EACH ROW EXECUTE PROCEDURE triggers.sort_prices();


--
-- Name: preview_courses sort_prices; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER sort_prices BEFORE INSERT OR UPDATE ON app.preview_courses FOR EACH ROW EXECUTE PROCEDURE triggers.sort_prices();


--
-- Name: admin_accounts track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.admin_accounts FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: admin_profiles track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.admin_profiles FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: certificates track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.certificates FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: contacts track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.contacts FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: course_reviews track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.course_reviews FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: courses track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.courses FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: crawler_domains track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.crawler_domains FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: crawling_events track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.crawling_events FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: direct_uploads track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.direct_uploads FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: enrollments track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.enrollments FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: favorites track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.favorites FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: images track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.images FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: landing_pages track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.landing_pages FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: oauth_accounts track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.oauth_accounts FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: orphaned_profiles track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.orphaned_profiles FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: posts track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.posts FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: preview_course_images track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.preview_course_images FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: preview_courses track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.preview_courses FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: profiles track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.profiles FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: promo_accounts track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.promo_accounts FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: provider_crawlers track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.provider_crawlers FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: providers track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.providers FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: slug_histories track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.slug_histories FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: tracked_actions track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.tracked_actions FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: tracked_searches track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.tracked_searches FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: user_accounts track_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON app.user_accounts FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: profiles use_username; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER use_username AFTER INSERT OR UPDATE ON app.profiles FOR EACH ROW EXECUTE PROCEDURE triggers.use_username();


--
-- Name: profiles validate_profiles; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER validate_profiles BEFORE INSERT OR UPDATE ON app.profiles FOR EACH ROW EXECUTE PROCEDURE triggers.validate_profiles();


--
-- Name: provider_crawlers validate_provider_crawler_urls; Type: TRIGGER; Schema: app; Owner: -
--

CREATE CONSTRAINT TRIGGER validate_provider_crawler_urls AFTER INSERT OR UPDATE ON app.provider_crawlers NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE triggers.validate_provider_crawler_urls();


--
-- Name: provider_crawlers validate_sitemaps; Type: TRIGGER; Schema: app; Owner: -
--

CREATE CONSTRAINT TRIGGER validate_sitemaps AFTER INSERT OR UPDATE ON app.provider_crawlers NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE triggers.validate_sitemaps();


--
-- Name: profiles validate_url; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER validate_url BEFORE INSERT OR UPDATE ON app.profiles FOR EACH ROW EXECUTE PROCEDURE triggers.validate_url();


--
-- Name: provider_crawlers validate_user_account_ids; Type: TRIGGER; Schema: app; Owner: -
--

CREATE CONSTRAINT TRIGGER validate_user_account_ids AFTER INSERT OR UPDATE ON app.provider_crawlers NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE triggers.validate_user_account_ids();


--
-- Name: profiles validate_website; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER validate_website BEFORE INSERT OR UPDATE ON app.profiles FOR EACH ROW EXECUTE PROCEDURE triggers.validate_website();


--
-- Name: que_jobs que_job_notify; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER que_job_notify AFTER INSERT ON public.que_jobs FOR EACH ROW EXECUTE PROCEDURE public.que_job_notify();


--
-- Name: que_jobs que_state_notify; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER que_state_notify AFTER INSERT OR DELETE OR UPDATE ON public.que_jobs FOR EACH ROW EXECUTE PROCEDURE public.que_state_notify();


--
-- Name: ar_internal_metadata track_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER track_updated_at BEFORE UPDATE ON public.ar_internal_metadata FOR EACH ROW EXECUTE PROCEDURE triggers.track_updated_at();


--
-- Name: admin_profiles admin_profiles_admin_account_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.admin_profiles
    ADD CONSTRAINT admin_profiles_admin_account_id_fkey FOREIGN KEY (admin_account_id) REFERENCES app.admin_accounts(id) ON DELETE CASCADE;


--
-- Name: certificates certificates_user_account_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.certificates
    ADD CONSTRAINT certificates_user_account_id_fkey FOREIGN KEY (user_account_id) REFERENCES app.user_accounts(id);


--
-- Name: course_reviews course_reviews_tracked_action_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.course_reviews
    ADD CONSTRAINT course_reviews_tracked_action_id_fkey FOREIGN KEY (tracked_action_id) REFERENCES app.tracked_actions(id) ON DELETE CASCADE;


--
-- Name: course_reviews course_reviews_user_account_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.course_reviews
    ADD CONSTRAINT course_reviews_user_account_id_fkey FOREIGN KEY (user_account_id) REFERENCES app.user_accounts(id) ON DELETE CASCADE;


--
-- Name: courses courses_provider_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.courses
    ADD CONSTRAINT courses_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES app.providers(id);


--
-- Name: courses courses_up_to_date_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.courses
    ADD CONSTRAINT courses_up_to_date_id_fkey FOREIGN KEY (up_to_date_id) REFERENCES app.courses(id) ON DELETE SET NULL;


--
-- Name: crawler_domains crawler_domains_provider_crawler_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.crawler_domains
    ADD CONSTRAINT crawler_domains_provider_crawler_id_fkey FOREIGN KEY (provider_crawler_id) REFERENCES app.provider_crawlers(id) ON DELETE CASCADE;


--
-- Name: crawling_events crawling_events_provider_crawler_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.crawling_events
    ADD CONSTRAINT crawling_events_provider_crawler_id_fkey FOREIGN KEY (provider_crawler_id) REFERENCES app.provider_crawlers(id) ON DELETE CASCADE;


--
-- Name: curated_tags_versions curated_tags_versions_course_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.curated_tags_versions
    ADD CONSTRAINT curated_tags_versions_course_id_fkey FOREIGN KEY (course_id) REFERENCES app.courses(id);


--
-- Name: direct_uploads direct_uploads_user_account_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.direct_uploads
    ADD CONSTRAINT direct_uploads_user_account_id_fkey FOREIGN KEY (user_account_id) REFERENCES app.user_accounts(id);


--
-- Name: enrollments enrollments_course_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.enrollments
    ADD CONSTRAINT enrollments_course_id_fkey FOREIGN KEY (course_id) REFERENCES app.courses(id);


--
-- Name: enrollments enrollments_provider_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.enrollments
    ADD CONSTRAINT enrollments_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES app.providers(id);


--
-- Name: enrollments enrollments_tracked_search_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.enrollments
    ADD CONSTRAINT enrollments_tracked_search_id_fkey FOREIGN KEY (tracked_search_id) REFERENCES app.tracked_searches(id);


--
-- Name: enrollments enrollments_user_account_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.enrollments
    ADD CONSTRAINT enrollments_user_account_id_fkey FOREIGN KEY (user_account_id) REFERENCES app.user_accounts(id);


--
-- Name: favorites favorites_course_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.favorites
    ADD CONSTRAINT favorites_course_id_fkey FOREIGN KEY (course_id) REFERENCES app.courses(id);


--
-- Name: favorites favorites_user_account_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.favorites
    ADD CONSTRAINT favorites_user_account_id_fkey FOREIGN KEY (user_account_id) REFERENCES app.user_accounts(id);


--
-- Name: oauth_accounts oauth_accounts_user_account_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.oauth_accounts
    ADD CONSTRAINT oauth_accounts_user_account_id_fkey FOREIGN KEY (user_account_id) REFERENCES app.user_accounts(id) ON DELETE CASCADE;


--
-- Name: orphaned_profiles orphaned_profiles_user_account_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.orphaned_profiles
    ADD CONSTRAINT orphaned_profiles_user_account_id_fkey FOREIGN KEY (user_account_id) REFERENCES app.user_accounts(id) ON DELETE CASCADE;


--
-- Name: post_relations post_relations_post_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.post_relations
    ADD CONSTRAINT post_relations_post_id_fkey FOREIGN KEY (post_id) REFERENCES app.posts(id);


--
-- Name: posts posts_admin_account_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.posts
    ADD CONSTRAINT posts_admin_account_id_fkey FOREIGN KEY (admin_account_id) REFERENCES app.admin_accounts(id);


--
-- Name: posts posts_original_post_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.posts
    ADD CONSTRAINT posts_original_post_id_fkey FOREIGN KEY (original_post_id) REFERENCES app.posts(id);


--
-- Name: preview_course_images preview_course_images_preview_course_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.preview_course_images
    ADD CONSTRAINT preview_course_images_preview_course_id_fkey FOREIGN KEY (preview_course_id) REFERENCES app.preview_courses(id);


--
-- Name: preview_courses preview_courses_provider_crawler_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.preview_courses
    ADD CONSTRAINT preview_courses_provider_crawler_id_fkey FOREIGN KEY (provider_crawler_id) REFERENCES app.provider_crawlers(id) ON DELETE CASCADE;


--
-- Name: preview_courses preview_courses_provider_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.preview_courses
    ADD CONSTRAINT preview_courses_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES app.providers(id);


--
-- Name: profiles profiles_user_account_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.profiles
    ADD CONSTRAINT profiles_user_account_id_fkey FOREIGN KEY (user_account_id) REFERENCES app.user_accounts(id) ON DELETE CASCADE;


--
-- Name: promo_account_logs promo_account_logs_promo_account_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.promo_account_logs
    ADD CONSTRAINT promo_account_logs_promo_account_id_fkey FOREIGN KEY (promo_account_id) REFERENCES app.promo_accounts(id) ON DELETE CASCADE;


--
-- Name: promo_accounts promo_accounts_certificate_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.promo_accounts
    ADD CONSTRAINT promo_accounts_certificate_id_fkey FOREIGN KEY (certificate_id) REFERENCES app.certificates(id) ON DELETE CASCADE;


--
-- Name: promo_accounts promo_accounts_user_account_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.promo_accounts
    ADD CONSTRAINT promo_accounts_user_account_id_fkey FOREIGN KEY (user_account_id) REFERENCES app.user_accounts(id) ON DELETE CASCADE;


--
-- Name: provider_crawlers provider_crawlers_provider_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.provider_crawlers
    ADD CONSTRAINT provider_crawlers_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES app.providers(id) ON DELETE CASCADE;


--
-- Name: provider_logos provider_logos_direct_upload_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.provider_logos
    ADD CONSTRAINT provider_logos_direct_upload_id_fkey FOREIGN KEY (direct_upload_id) REFERENCES app.direct_uploads(id);


--
-- Name: provider_logos provider_logos_provider_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.provider_logos
    ADD CONSTRAINT provider_logos_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES app.providers(id);


--
-- Name: slug_histories slug_histories_course_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.slug_histories
    ADD CONSTRAINT slug_histories_course_id_fkey FOREIGN KEY (course_id) REFERENCES app.courses(id) ON DELETE CASCADE;


--
-- Name: subscriptions subscriptions_profile_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.subscriptions
    ADD CONSTRAINT subscriptions_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES app.profiles(id);


--
-- Name: tracked_actions tracked_actions_enrollment_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.tracked_actions
    ADD CONSTRAINT tracked_actions_enrollment_id_fkey FOREIGN KEY (enrollment_id) REFERENCES app.enrollments(id);


--
-- Name: used_usernames used_usernames_profile_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.used_usernames
    ADD CONSTRAINT used_usernames_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES app.profiles(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO app,public,api;

INSERT INTO "schema_migrations" (version) VALUES
('20180101010101'),
('20180101010102'),
('20180101010103'),
('20180101010104'),
('20180101010105'),
('20180101010106'),
('20180101010107'),
('20180101010108'),
('20180101010109'),
('20180405131603'),
('20180405131604'),
('20180523201233'),
('20180523201244'),
('20180525023807'),
('20180607040455'),
('20180607042446'),
('20181015193451'),
('20181015193452'),
('20181017123839'),
('20181018075955'),
('20181030111522'),
('20181102111502'),
('20181113000000'),
('20181115164155'),
('20181115164156'),
('20181127193928'),
('20181128123550'),
('20181129103819'),
('20181205214627'),
('20181206020722'),
('20181213172406'),
('20181214163153'),
('20181217193900'),
('20181219141415'),
('20181220182109'),
('20181226142754'),
('20190122215523'),
('20190208194421'),
('20190216154846'),
('20190217234501'),
('20190218212408'),
('20190220000225'),
('20190222125654'),
('20190226205725'),
('20190226205726'),
('20190226223828'),
('20190228203835'),
('20190228220559'),
('20190306194201'),
('20190310005126'),
('20190310024220'),
('20190310031745'),
('20190310032740'),
('20190310062807'),
('20190313223626'),
('20190313223627'),
('20190328144400'),
('20190408141738'),
('20190408173350'),
('20190416123653'),
('20190503093752'),
('20190506184046'),
('20190515101502'),
('20190515104037'),
('20190521153938'),
('20190529190629'),
('20190606133958'),
('20190607133958'),
('20190610174143'),
('20190611223206'),
('20190615220137'),
('20190616024703'),
('20190705153206'),
('20190805181853'),
('20190819000000'),
('20190819214900'),
('20190826172519'),
('20190830142600'),
('20190830143200'),
('20190830150100'),
('20190830151600'),
('20190910140600'),
('20190919074600'),
('20190919165000'),
('20190919170100'),
('20190919170101'),
('20190923175923'),
('20191009074600'),
('20191017152900'),
('20191107132512'),
('20191107173251'),
('20191108115021'),
('20191111180132'),
('20191209180900'),
('20191212123500'),
('20191226144400'),
('20200107070000'),
('20200128095304'),
('20200203120812'),
('20200203165316'),
('20200203183213'),
('20200211192257'),
('20200213183318'),
('20200217174600'),
('20200218175146'),
('20200221092300'),
('20200221182700'),
('20200304173100'),
('20200307102619'),
('20200310145105'),
('20200311142800'),
('20200316074600'),
('20200319071300'),
('20200322074600'),
('20200327164000'),
('20200401180601'),
('20200417184601'),
('20200511124730'),
('20200513185742'),
('20200514221948'),
('20200521195121'),
('20200522194450'),
('20200525145059'),
('20200526201913'),
('20200528231134'),
('20200530022039'),
('20200602150635'),
('20200610204428'),
('20200611152646'),
('20200611173112'),
('20200616020721'),
('20200619152842'),
('20200623184524'),
('20200626162146'),
('20200628233835'),
('20200629194941'),
('20200701142918'),
('20200701200531'),
('20200703150025'),
('20200706172252'),
('20200707144858'),
('20200707202743'),
('20200708161246'),
('20200708161247'),
('20200709184800'),
('20200715010430'),
('20200715023408'),
('20200715184252'),
('20200716012222'),
('20200716185848');


