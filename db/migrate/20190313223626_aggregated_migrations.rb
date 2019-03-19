class AggregatedMigrations < ActiveRecord::Migration[5.1]

  def change
    execute <<-SQL
      SET statement_timeout = 0;
      SET lock_timeout = 0;
      SET idle_in_transaction_session_timeout = 0;
      SET client_encoding = 'UTF8';
      SET standard_conforming_strings = on;
      SELECT pg_catalog.set_config('search_path', '', false);
      SET check_function_bodies = false;
      SET client_min_messages = warning;
      SET row_security = off;

      --
      -- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
      --

      CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


      --
      -- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
      --

      COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


      --
      -- Name: citext; Type: EXTENSION; Schema: -; Owner: -
      --

      CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


      --
      -- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
      --

      COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


      --
      -- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
      --

      CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


      --
      -- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
      --

      COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


      --
      -- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
      --

      CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


      --
      -- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
      --

      COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


      --
      -- Name: category; Type: TYPE; Schema: public; Owner: -
      --

      CREATE TYPE public.category AS ENUM (
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
      -- Name: level; Type: TYPE; Schema: public; Owner: -
      --

      CREATE TYPE public.level AS ENUM (
          'beginner',
          'intermediate',
          'advanced'
      );


      --
      -- Name: pace; Type: TYPE; Schema: public; Owner: -
      --

      CREATE TYPE public.pace AS ENUM (
          'self_paced',
          'instructor_paced'
      );


      --
      -- Name: payment_source; Type: TYPE; Schema: public; Owner: -
      --

      CREATE TYPE public.payment_source AS ENUM (
          'impact_radius',
          'awin',
          'rakuten',
          'share_a_sale',
          'commission_junction',
          'zanox'
      );


      --
      -- Name: payment_status; Type: TYPE; Schema: public; Owner: -
      --

      CREATE TYPE public.payment_status AS ENUM (
          'open',
          'locked',
          'paid'
      );


      --
      -- Name: source; Type: TYPE; Schema: public; Owner: -
      --

      CREATE TYPE public.source AS ENUM (
          'api',
          'import',
          'admin'
      );


      --
      -- Name: _insert_or_add_to_provider(); Type: FUNCTION; Schema: public; Owner: -
      --

      CREATE FUNCTION public._insert_or_add_to_provider() RETURNS trigger
          LANGUAGE plpgsql
          AS $$
            DECLARE
              _provider providers%ROWTYPE;
              _new_provider_id int;
            BEGIN
              SELECT * FROM providers INTO _provider where providers.name = NEW.__provider_name__;
              IF (NOT FOUND) THEN
                INSERT INTO providers (name, published, created_at, updated_at) VALUES (NEW.__provider_name__, false, NOW(), NOW()) RETURNING id INTO _new_provider_id;
                NEW.published = false;
                NEW.provider_id = _new_provider_id;
              ELSE
                NEW.provider_id = _provider.id;
              END IF;
              RETURN NEW;
            END;
            $$;


      --
      -- Name: gen_compound_ext_id(); Type: FUNCTION; Schema: public; Owner: -
      --

      CREATE FUNCTION public.gen_compound_ext_id() RETURNS trigger
          LANGUAGE plpgsql
          AS $$
            BEGIN
              NEW.compound_ext_id = concat(NEW.source,'_',NEW.ext_id);
              return NEW;
            END
            $$;


      --
      -- Name: md5_url(); Type: FUNCTION; Schema: public; Owner: -
      --

      CREATE FUNCTION public.md5_url() RETURNS trigger
          LANGUAGE plpgsql
          AS $$
            BEGIN
              NEW.url_md5=md5(NEW.url);
              return NEW;
            END
            $$;


      --
      -- Name: sort_prices(); Type: FUNCTION; Schema: public; Owner: -
      --

      CREATE FUNCTION public.sort_prices() RETURNS trigger
          LANGUAGE plpgsql
          AS $$
            DECLARE
            price jsonb;
            prices jsonb[];
            results jsonb[];
            single_course_prices jsonb[];
            subscription_prices jsonb[];
            BEGIN
              FOR price IN SELECT * FROM jsonb_array_elements((NEW.__source_schema__ -> 'content' ->> 'prices')::jsonb)
              LOOP
                IF (price ->> 'type' = 'single_course') THEN
                  single_course_prices := array_append(single_course_prices,price);
                ELSIF (price ->> 'type' = 'subscription') THEN
                  IF (price -> 'subscription_period' ->> 'unit' = 'months') THEN
                    subscription_prices := array_prepend(price,subscription_prices);
                  ELSIF (price -> 'subscription_period' ->> 'unit' = 'years') THEN
                    subscription_prices := array_append(subscription_prices,price);
                  END IF;
                END IF;
              END LOOP;
              results := (single_course_prices || subscription_prices);
              IF array_length(results,1) > 0 THEN
                NEW.pricing_models = to_jsonb(results);
              END IF;
              NEW.__source_schema__ = NULL;
              RETURN NEW;
            END;
            $$;


      SET default_tablespace = '';

      SET default_with_oids = false;

      --
      -- Name: admin_accounts; Type: TABLE; Schema: public; Owner: -
      --

      CREATE TABLE public.admin_accounts (
          id bigint NOT NULL,
          email character varying DEFAULT ''::character varying NOT NULL,
          encrypted_password character varying DEFAULT ''::character varying NOT NULL,
          reset_password_token character varying,
          reset_password_sent_at timestamp without time zone,
          remember_created_at timestamp without time zone,
          sign_in_count integer DEFAULT 0 NOT NULL,
          current_sign_in_at timestamp without time zone,
          last_sign_in_at timestamp without time zone,
          current_sign_in_ip inet,
          last_sign_in_ip inet,
          confirmation_token character varying,
          confirmed_at timestamp without time zone,
          confirmation_sent_at timestamp without time zone,
          unconfirmed_email character varying,
          failed_attempts integer DEFAULT 0 NOT NULL,
          unlock_token character varying,
          locked_at timestamp without time zone,
          created_at timestamp without time zone NOT NULL,
          updated_at timestamp without time zone NOT NULL,
          preferences jsonb DEFAULT '{}'::jsonb
      );


      --
      -- Name: admin_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
      --

      CREATE SEQUENCE public.admin_accounts_id_seq
          START WITH 1
          INCREMENT BY 1
          NO MINVALUE
          NO MAXVALUE
          CACHE 1;


      --
      -- Name: admin_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
      --

      ALTER SEQUENCE public.admin_accounts_id_seq OWNED BY public.admin_accounts.id;

      --
      -- Name: courses; Type: TABLE; Schema: public; Owner: -
      --

      CREATE TABLE public.courses (
          id uuid DEFAULT public.gen_random_uuid() NOT NULL,
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
          published boolean,
          stale boolean DEFAULT false,
          category public.category,
          provider_id bigint,
          created_at timestamp without time zone NOT NULL,
          updated_at timestamp without time zone NOT NULL,
          dataset_sequence integer,
          resource_sequence integer,
          tags text[] DEFAULT '{}'::text[],
          video jsonb,
          source character varying,
          pace public.pace,
          certificate jsonb DEFAULT '"{}"'::jsonb,
          pricing_models jsonb DEFAULT '"[]"'::jsonb,
          offered_by jsonb DEFAULT '"[]"'::jsonb,
          syllabus text,
          effort integer,
          enrollments_count integer DEFAULT 0,
          free_content boolean DEFAULT false,
          paid_content boolean DEFAULT true,
          level public.level[] DEFAULT '{}'::public.level[],
          __provider_name__ character varying,
          __source_schema__ jsonb
      );


      --
      -- Name: enrollments; Type: TABLE; Schema: public; Owner: -
      --

      CREATE TABLE public.enrollments (
          user_rating numeric,
          description text,
          tracked_url character varying,
          tracking_data jsonb DEFAULT '{}'::jsonb,
          user_account_id bigint,
          course_id uuid,
          created_at timestamp without time zone NOT NULL,
          updated_at timestamp without time zone NOT NULL,
          id uuid DEFAULT public.uuid_generate_v4() NOT NULL
      );


      --
      -- Name: providers; Type: TABLE; Schema: public; Owner: -
      --

      CREATE TABLE public.providers (
          id bigint NOT NULL,
          name public.citext,
          description text,
          slug character varying,
          afn_url_template character varying,
          published boolean,
          published_at timestamp without time zone,
          created_at timestamp without time zone NOT NULL,
          updated_at timestamp without time zone NOT NULL,
          encoded_deep_linking boolean DEFAULT false
      );


      --
      -- Name: tracked_actions; Type: TABLE; Schema: public; Owner: -
      --

      CREATE TABLE public.tracked_actions (
          id uuid DEFAULT public.gen_random_uuid() NOT NULL,
          sale_amount numeric,
          earnings_amount numeric,
          payload jsonb,
          source public.payment_source,
          status public.payment_status,
          created_at timestamp without time zone NOT NULL,
          updated_at timestamp without time zone NOT NULL,
          enrollment_id uuid,
          ext_click_date timestamp without time zone,
          ext_id character varying,
          compound_ext_id character varying,
          ext_sku_id character varying,
          ext_sku_name character varying
      );


      --
      -- Name: earnings; Type: VIEW; Schema: public; Owner: -
      --

      CREATE VIEW public.earnings AS
       SELECT tracked_actions.id,
          tracked_actions.sale_amount,
          tracked_actions.earnings_amount,
          tracked_actions.ext_click_date,
          tracked_actions.ext_sku_id,
          tracked_actions.ext_sku_name,
          tracked_actions.ext_id,
          tracked_actions.source AS affiliate_network,
          providers.name AS provider_name,
          courses.name AS course_name,
          courses.url AS course_url,
          (enrollments.tracking_data ->> 'query_string'::text) AS qs,
          (enrollments.tracking_data ->> 'referer'::text) AS referer,
          (enrollments.tracking_data ->> 'utm_source'::text) AS utm_source,
          (enrollments.tracking_data ->> 'utm_campaign'::text) AS utm_campaign,
          (enrollments.tracking_data ->> 'utm_medium'::text) AS utm_medium,
          (enrollments.tracking_data ->> 'utm_term'::text) AS utm_term,
          tracked_actions.created_at
         FROM (((public.tracked_actions
           LEFT JOIN public.enrollments ON ((tracked_actions.enrollment_id = enrollments.id)))
           LEFT JOIN public.courses ON ((enrollments.course_id = courses.id)))
           LEFT JOIN public.providers ON ((courses.provider_id = providers.id)));


      --
      -- Name: favorites; Type: TABLE; Schema: public; Owner: -
      --

      CREATE TABLE public.favorites (
          id bigint NOT NULL,
          user_account_id bigint,
          course_id bigint,
          created_at timestamp without time zone NOT NULL,
          updated_at timestamp without time zone NOT NULL
      );


      --
      -- Name: favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
      --

      CREATE SEQUENCE public.favorites_id_seq
          START WITH 1
          INCREMENT BY 1
          NO MINVALUE
          NO MAXVALUE
          CACHE 1;


      --
      -- Name: favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
      --

      ALTER SEQUENCE public.favorites_id_seq OWNED BY public.favorites.id;


      --
      -- Name: images; Type: TABLE; Schema: public; Owner: -
      --

      CREATE TABLE public.images (
          id bigint NOT NULL,
          caption character varying,
          file character varying,
          pos integer DEFAULT 0,
          imageable_type character varying,
          imageable_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone
      );


      --
      -- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
      --

      CREATE SEQUENCE public.images_id_seq
          START WITH 1
          INCREMENT BY 1
          NO MINVALUE
          NO MAXVALUE
          CACHE 1;


      --
      -- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
      --

      ALTER SEQUENCE public.images_id_seq OWNED BY public.images.id;


      --
      -- Name: landing_pages; Type: TABLE; Schema: public; Owner: -
      --

      CREATE TABLE public.landing_pages (
          id bigint NOT NULL,
          slug public.citext,
          template character varying,
          meta_html text,
          html jsonb DEFAULT '{}'::jsonb,
          body_html text,
          created_at timestamp without time zone NOT NULL,
          updated_at timestamp without time zone NOT NULL,
          data jsonb DEFAULT '{}'::jsonb,
          erb_template text,
          layout character varying
      );


      --
      -- Name: landing_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
      --

      CREATE SEQUENCE public.landing_pages_id_seq
          START WITH 1
          INCREMENT BY 1
          NO MINVALUE
          NO MAXVALUE
          CACHE 1;


      --
      -- Name: landing_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
      --

      ALTER SEQUENCE public.landing_pages_id_seq OWNED BY public.landing_pages.id;


      --
      -- Name: oauth_accounts; Type: TABLE; Schema: public; Owner: -
      --

      CREATE TABLE public.oauth_accounts (
          id bigint NOT NULL,
          provider character varying,
          uid character varying,
          raw_data jsonb DEFAULT '{}'::jsonb NOT NULL,
          user_account_id bigint,
          created_at timestamp without time zone NOT NULL,
          updated_at timestamp without time zone NOT NULL
      );


      --
      -- Name: oauth_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
      --

      CREATE SEQUENCE public.oauth_accounts_id_seq
          START WITH 1
          INCREMENT BY 1
          NO MINVALUE
          NO MAXVALUE
          CACHE 1;


      --
      -- Name: oauth_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
      --

      ALTER SEQUENCE public.oauth_accounts_id_seq OWNED BY public.oauth_accounts.id;


      --
      -- Name: profiles; Type: TABLE; Schema: public; Owner: -
      --

      CREATE TABLE public.profiles (
          id bigint NOT NULL,
          name character varying,
          date_of_birth date,
          avatar character varying,
          interests text[] DEFAULT '{}'::text[],
          preferences jsonb DEFAULT '{}'::jsonb,
          user_account_id bigint
      );


      --
      -- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
      --

      CREATE SEQUENCE public.profiles_id_seq
          START WITH 1
          INCREMENT BY 1
          NO MINVALUE
          NO MAXVALUE
          CACHE 1;


      --
      -- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
      --

      ALTER SEQUENCE public.profiles_id_seq OWNED BY public.profiles.id;


      --
      -- Name: providers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
      --

      CREATE SEQUENCE public.providers_id_seq
          START WITH 1
          INCREMENT BY 1
          NO MINVALUE
          NO MAXVALUE
          CACHE 1;


      --
      -- Name: providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
      --

      ALTER SEQUENCE public.providers_id_seq OWNED BY public.providers.id;

      --
      -- Name: user_accounts; Type: TABLE; Schema: public; Owner: -
      --

      CREATE TABLE public.user_accounts (
          id bigint NOT NULL,
          email character varying DEFAULT ''::character varying NOT NULL,
          encrypted_password character varying DEFAULT ''::character varying NOT NULL,
          reset_password_token character varying,
          reset_password_sent_at timestamp without time zone,
          remember_created_at timestamp without time zone,
          sign_in_count integer DEFAULT 0 NOT NULL,
          current_sign_in_at timestamp without time zone,
          last_sign_in_at timestamp without time zone,
          current_sign_in_ip inet,
          last_sign_in_ip inet,
          tracking_data json DEFAULT '{}'::json NOT NULL,
          confirmation_token character varying,
          confirmed_at timestamp without time zone,
          confirmation_sent_at timestamp without time zone,
          unconfirmed_email character varying,
          failed_attempts integer DEFAULT 0 NOT NULL,
          unlock_token character varying,
          locked_at timestamp without time zone,
          destroyed_at timestamp without time zone,
          created_at timestamp without time zone NOT NULL,
          updated_at timestamp without time zone NOT NULL
      );


      --
      -- Name: user_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
      --

      CREATE SEQUENCE public.user_accounts_id_seq
          START WITH 1
          INCREMENT BY 1
          NO MINVALUE
          NO MAXVALUE
          CACHE 1;


      --
      -- Name: user_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
      --

      ALTER SEQUENCE public.user_accounts_id_seq OWNED BY public.user_accounts.id;


      --
      -- Name: admin_accounts id; Type: DEFAULT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.admin_accounts ALTER COLUMN id SET DEFAULT nextval('public.admin_accounts_id_seq'::regclass);


      --
      -- Name: favorites id; Type: DEFAULT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.favorites ALTER COLUMN id SET DEFAULT nextval('public.favorites_id_seq'::regclass);


      --
      -- Name: images id; Type: DEFAULT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.images ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);


      --
      -- Name: landing_pages id; Type: DEFAULT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.landing_pages ALTER COLUMN id SET DEFAULT nextval('public.landing_pages_id_seq'::regclass);


      --
      -- Name: oauth_accounts id; Type: DEFAULT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.oauth_accounts ALTER COLUMN id SET DEFAULT nextval('public.oauth_accounts_id_seq'::regclass);


      --
      -- Name: profiles id; Type: DEFAULT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.profiles ALTER COLUMN id SET DEFAULT nextval('public.profiles_id_seq'::regclass);


      --
      -- Name: providers id; Type: DEFAULT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.providers ALTER COLUMN id SET DEFAULT nextval('public.providers_id_seq'::regclass);


      --
      -- Name: user_accounts id; Type: DEFAULT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.user_accounts ALTER COLUMN id SET DEFAULT nextval('public.user_accounts_id_seq'::regclass);


      --
      -- Name: admin_accounts admin_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.admin_accounts
          ADD CONSTRAINT admin_accounts_pkey PRIMARY KEY (id);


      --
      -- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.courses
          ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


      --
      -- Name: enrollments enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.enrollments
          ADD CONSTRAINT enrollments_pkey PRIMARY KEY (id);


      --
      -- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.favorites
          ADD CONSTRAINT favorites_pkey PRIMARY KEY (id);


      --
      -- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.images
          ADD CONSTRAINT images_pkey PRIMARY KEY (id);


      --
      -- Name: landing_pages landing_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.landing_pages
          ADD CONSTRAINT landing_pages_pkey PRIMARY KEY (id);


      --
      -- Name: oauth_accounts oauth_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.oauth_accounts
          ADD CONSTRAINT oauth_accounts_pkey PRIMARY KEY (id);


      --
      -- Name: tracked_actions payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.tracked_actions
          ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


      --
      -- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.profiles
          ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


      --
      -- Name: providers providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.providers
          ADD CONSTRAINT providers_pkey PRIMARY KEY (id);


      --
      -- Name: user_accounts user_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.user_accounts
          ADD CONSTRAINT user_accounts_pkey PRIMARY KEY (id);


      --
      -- Name: index_admin_accounts_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
      --

      CREATE UNIQUE INDEX index_admin_accounts_on_confirmation_token ON public.admin_accounts USING btree (confirmation_token);


      --
      -- Name: index_admin_accounts_on_email; Type: INDEX; Schema: public; Owner: -
      --

      CREATE UNIQUE INDEX index_admin_accounts_on_email ON public.admin_accounts USING btree (email);


      --
      -- Name: index_admin_accounts_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
      --

      CREATE UNIQUE INDEX index_admin_accounts_on_reset_password_token ON public.admin_accounts USING btree (reset_password_token);


      --
      -- Name: index_admin_accounts_on_unlock_token; Type: INDEX; Schema: public; Owner: -
      --

      CREATE UNIQUE INDEX index_admin_accounts_on_unlock_token ON public.admin_accounts USING btree (unlock_token);


      --
      -- Name: index_courses_on_dataset_sequence; Type: INDEX; Schema: public; Owner: -
      --

      CREATE INDEX index_courses_on_dataset_sequence ON public.courses USING btree (dataset_sequence);


      --
      -- Name: index_courses_on_global_sequence; Type: INDEX; Schema: public; Owner: -
      --

      CREATE INDEX index_courses_on_global_sequence ON public.courses USING btree (global_sequence);


      --
      -- Name: index_courses_on_provider_id; Type: INDEX; Schema: public; Owner: -
      --

      CREATE INDEX index_courses_on_provider_id ON public.courses USING btree (provider_id);


      --
      -- Name: index_courses_on_slug; Type: INDEX; Schema: public; Owner: -
      --

      CREATE UNIQUE INDEX index_courses_on_slug ON public.courses USING btree (slug);


      --
      -- Name: index_courses_on_tags; Type: INDEX; Schema: public; Owner: -
      --

      CREATE INDEX index_courses_on_tags ON public.courses USING gin (tags);


      --
      -- Name: index_courses_on_url_md5; Type: INDEX; Schema: public; Owner: -
      --

      CREATE UNIQUE INDEX index_courses_on_url_md5 ON public.courses USING btree (url_md5);


      --
      -- Name: index_enrollments_on_course_id; Type: INDEX; Schema: public; Owner: -
      --

      CREATE INDEX index_enrollments_on_course_id ON public.enrollments USING btree (course_id);


      --
      -- Name: index_enrollments_on_tracking_data; Type: INDEX; Schema: public; Owner: -
      --

      CREATE INDEX index_enrollments_on_tracking_data ON public.enrollments USING gin (tracking_data);


      --
      -- Name: index_enrollments_on_user_account_id; Type: INDEX; Schema: public; Owner: -
      --

      CREATE INDEX index_enrollments_on_user_account_id ON public.enrollments USING btree (user_account_id);


      --
      -- Name: index_favorites_on_course_id; Type: INDEX; Schema: public; Owner: -
      --

      CREATE INDEX index_favorites_on_course_id ON public.favorites USING btree (course_id);


      --
      -- Name: index_favorites_on_user_account_id; Type: INDEX; Schema: public; Owner: -
      --

      CREATE INDEX index_favorites_on_user_account_id ON public.favorites USING btree (user_account_id);


      --
      -- Name: index_images_on_imageable_type_and_imageable_id; Type: INDEX; Schema: public; Owner: -
      --

      CREATE INDEX index_images_on_imageable_type_and_imageable_id ON public.images USING btree (imageable_type, imageable_id);


      --
      -- Name: index_landing_pages_on_slug; Type: INDEX; Schema: public; Owner: -
      --

      CREATE UNIQUE INDEX index_landing_pages_on_slug ON public.landing_pages USING btree (slug);


      --
      -- Name: index_oauth_accounts_on_user_account_id; Type: INDEX; Schema: public; Owner: -
      --

      CREATE INDEX index_oauth_accounts_on_user_account_id ON public.oauth_accounts USING btree (user_account_id);


      --
      -- Name: index_profiles_on_user_account_id; Type: INDEX; Schema: public; Owner: -
      --

      CREATE INDEX index_profiles_on_user_account_id ON public.profiles USING btree (user_account_id);


      --
      -- Name: index_providers_on_name; Type: INDEX; Schema: public; Owner: -
      --

      CREATE UNIQUE INDEX index_providers_on_name ON public.providers USING btree (name);


      --
      -- Name: index_providers_on_slug; Type: INDEX; Schema: public; Owner: -
      --

      CREATE UNIQUE INDEX index_providers_on_slug ON public.providers USING btree (slug);


      --
      -- Name: index_tracked_actions_on_compound_ext_id; Type: INDEX; Schema: public; Owner: -
      --

      CREATE UNIQUE INDEX index_tracked_actions_on_compound_ext_id ON public.tracked_actions USING btree (compound_ext_id);


      --
      -- Name: index_tracked_actions_on_enrollment_id; Type: INDEX; Schema: public; Owner: -
      --

      CREATE INDEX index_tracked_actions_on_enrollment_id ON public.tracked_actions USING btree (enrollment_id);


      --
      -- Name: index_tracked_actions_on_payload; Type: INDEX; Schema: public; Owner: -
      --

      CREATE INDEX index_tracked_actions_on_payload ON public.tracked_actions USING gin (payload);


      --
      -- Name: index_tracked_actions_on_status; Type: INDEX; Schema: public; Owner: -
      --

      CREATE INDEX index_tracked_actions_on_status ON public.tracked_actions USING btree (status);


      --
      -- Name: index_user_accounts_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
      --

      CREATE UNIQUE INDEX index_user_accounts_on_confirmation_token ON public.user_accounts USING btree (confirmation_token);


      --
      -- Name: index_user_accounts_on_email; Type: INDEX; Schema: public; Owner: -
      --

      CREATE UNIQUE INDEX index_user_accounts_on_email ON public.user_accounts USING btree (email);


      --
      -- Name: index_user_accounts_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
      --

      CREATE UNIQUE INDEX index_user_accounts_on_reset_password_token ON public.user_accounts USING btree (reset_password_token);


      --
      -- Name: index_user_accounts_on_unlock_token; Type: INDEX; Schema: public; Owner: -
      --

      CREATE UNIQUE INDEX index_user_accounts_on_unlock_token ON public.user_accounts USING btree (unlock_token);


      --
      -- Name: tracked_actions set_compound_ext_id; Type: TRIGGER; Schema: public; Owner: -
      --

      CREATE TRIGGER set_compound_ext_id BEFORE INSERT ON public.tracked_actions FOR EACH ROW EXECUTE PROCEDURE public.gen_compound_ext_id();


      --
      -- Name: courses set_global_id; Type: TRIGGER; Schema: public; Owner: -
      --

      CREATE TRIGGER set_global_id BEFORE INSERT ON public.courses FOR EACH ROW EXECUTE PROCEDURE public.md5_url();


      --
      -- Name: courses sort_prices; Type: TRIGGER; Schema: public; Owner: -
      --

      CREATE TRIGGER sort_prices BEFORE INSERT OR UPDATE ON public.courses FOR EACH ROW EXECUTE PROCEDURE public.sort_prices();


      --
      -- Name: profiles fk_rails_2681856977; Type: FK CONSTRAINT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.profiles
          ADD CONSTRAINT fk_rails_2681856977 FOREIGN KEY (user_account_id) REFERENCES public.user_accounts(id);


      --
      -- Name: oauth_accounts fk_rails_b5f7319fb1; Type: FK CONSTRAINT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.oauth_accounts
          ADD CONSTRAINT fk_rails_b5f7319fb1 FOREIGN KEY (user_account_id) REFERENCES public.user_accounts(id);


      --
      -- Name: favorites fk_rails_b7f52d3501; Type: FK CONSTRAINT; Schema: public; Owner: -
      --

      ALTER TABLE ONLY public.favorites
          ADD CONSTRAINT fk_rails_b7f52d3501 FOREIGN KEY (user_account_id) REFERENCES public.user_accounts(id);


      --
      -- PostgreSQL database dump complete
      --

      SET search_path TO "$user", public;

    SQL
  end

end
