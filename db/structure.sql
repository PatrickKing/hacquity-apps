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


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: connection_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.connection_requests (
    id bigint NOT NULL,
    initiator_id bigint,
    receiver_id bigint,
    initiator_service_posting_id bigint,
    receiver_service_posting_id bigint,
    receiver_status character varying,
    initiator_status character varying,
    connection_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    resolved boolean
);


--
-- Name: connection_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.connection_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: connection_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.connection_requests_id_seq OWNED BY public.connection_requests.id;


--
-- Name: connections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.connections (
    id bigint NOT NULL,
    first_user_id bigint,
    second_user_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: connections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.connections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: connections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.connections_id_seq OWNED BY public.connections.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delayed_jobs (
    id bigint NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying,
    queue character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delayed_jobs_id_seq OWNED BY public.delayed_jobs.id;


--
-- Name: mentor_match_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentor_match_profiles (
    id bigint NOT NULL,
    user_id bigint,
    match_role character varying,
    "position" character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    original_cv_drive_id character varying,
    uploaded_cv_exists boolean,
    seeking_summary character varying,
    web_view_link character varying
);


--
-- Name: mentor_match_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentor_match_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentor_match_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mentor_match_profiles_id_seq OWNED BY public.mentor_match_profiles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: service_postings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_postings (
    id bigint NOT NULL,
    posting_type character varying,
    summary character varying,
    description character varying,
    full_time_equivalents numeric,
    user_id bigint,
    closed boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    service_type character varying
);


--
-- Name: service_postings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.service_postings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_postings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.service_postings_id_seq OWNED BY public.service_postings.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
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
    second_shift_enabled boolean,
    mentor_match_enabled boolean
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vendor_review_likes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vendor_review_likes (
    id bigint NOT NULL,
    user_id bigint,
    vendor_review_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    helpfulness integer
);


--
-- Name: vendor_review_likes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vendor_review_likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vendor_review_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vendor_review_likes_id_seq OWNED BY public.vendor_review_likes.id;


--
-- Name: vendor_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vendor_reviews (
    id bigint NOT NULL,
    user_id bigint,
    likes integer,
    title character varying,
    body character varying,
    vendor_name character varying,
    vendor_address_line1 character varying,
    vendor_address_line2 character varying,
    vendor_email_address character varying,
    vendor_phone_number character varying,
    vendor_contact_instructions character varying,
    vendor_services character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    text_search_document tsvector
);


--
-- Name: vendor_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vendor_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vendor_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vendor_reviews_id_seq OWNED BY public.vendor_reviews.id;


--
-- Name: connection_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connection_requests ALTER COLUMN id SET DEFAULT nextval('public.connection_requests_id_seq'::regclass);


--
-- Name: connections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connections ALTER COLUMN id SET DEFAULT nextval('public.connections_id_seq'::regclass);


--
-- Name: delayed_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs ALTER COLUMN id SET DEFAULT nextval('public.delayed_jobs_id_seq'::regclass);


--
-- Name: mentor_match_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_match_profiles ALTER COLUMN id SET DEFAULT nextval('public.mentor_match_profiles_id_seq'::regclass);


--
-- Name: service_postings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_postings ALTER COLUMN id SET DEFAULT nextval('public.service_postings_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vendor_review_likes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_review_likes ALTER COLUMN id SET DEFAULT nextval('public.vendor_review_likes_id_seq'::regclass);


--
-- Name: vendor_reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_reviews ALTER COLUMN id SET DEFAULT nextval('public.vendor_reviews_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: connection_requests connection_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connection_requests
    ADD CONSTRAINT connection_requests_pkey PRIMARY KEY (id);


--
-- Name: connections connections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connections
    ADD CONSTRAINT connections_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: mentor_match_profiles mentor_match_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_match_profiles
    ADD CONSTRAINT mentor_match_profiles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: service_postings service_postings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_postings
    ADD CONSTRAINT service_postings_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vendor_review_likes vendor_review_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_review_likes
    ADD CONSTRAINT vendor_review_likes_pkey PRIMARY KEY (id);


--
-- Name: vendor_reviews vendor_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_reviews
    ADD CONSTRAINT vendor_reviews_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delayed_jobs_priority ON public.delayed_jobs USING btree (priority, run_at);


--
-- Name: index_connection_requests_on_initiator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_connection_requests_on_initiator_id ON public.connection_requests USING btree (initiator_id);


--
-- Name: index_connection_requests_on_initiator_service_posting_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_connection_requests_on_initiator_service_posting_id ON public.connection_requests USING btree (initiator_service_posting_id);


--
-- Name: index_connection_requests_on_receiver_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_connection_requests_on_receiver_id ON public.connection_requests USING btree (receiver_id);


--
-- Name: index_connection_requests_on_receiver_service_posting_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_connection_requests_on_receiver_service_posting_id ON public.connection_requests USING btree (receiver_service_posting_id);


--
-- Name: index_connections_on_first_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_connections_on_first_user_id ON public.connections USING btree (first_user_id);


--
-- Name: index_connections_on_second_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_connections_on_second_user_id ON public.connections USING btree (second_user_id);


--
-- Name: index_mentor_match_profiles_on_original_cv_drive_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mentor_match_profiles_on_original_cv_drive_id ON public.mentor_match_profiles USING btree (original_cv_drive_id);


--
-- Name: index_mentor_match_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mentor_match_profiles_on_user_id ON public.mentor_match_profiles USING btree (user_id);


--
-- Name: index_service_postings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_postings_on_user_id ON public.service_postings USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_vendor_review_likes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vendor_review_likes_on_user_id ON public.vendor_review_likes USING btree (user_id);


--
-- Name: index_vendor_review_likes_on_vendor_review_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vendor_review_likes_on_vendor_review_id ON public.vendor_review_likes USING btree (vendor_review_id);


--
-- Name: index_vendor_reviews_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vendor_reviews_on_user_id ON public.vendor_reviews USING btree (user_id);


--
-- Name: vendor_reviews_fts_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX vendor_reviews_fts_idx ON public.vendor_reviews USING gin (text_search_document);


--
-- Name: vendor_reviews vendor_reviews_fts_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER vendor_reviews_fts_update BEFORE INSERT OR UPDATE ON public.vendor_reviews FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('text_search_document', 'pg_catalog.english', 'title', 'body', 'vendor_name', 'vendor_services');


--
-- Name: connection_requests fk_rails_14b982e77e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connection_requests
    ADD CONSTRAINT fk_rails_14b982e77e FOREIGN KEY (receiver_id) REFERENCES public.users(id);


--
-- Name: vendor_review_likes fk_rails_343bc8bf08; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_review_likes
    ADD CONSTRAINT fk_rails_343bc8bf08 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: mentor_match_profiles fk_rails_8a85be6f1c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_match_profiles
    ADD CONSTRAINT fk_rails_8a85be6f1c FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: service_postings fk_rails_8d397dd579; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_postings
    ADD CONSTRAINT fk_rails_8d397dd579 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: vendor_review_likes fk_rails_9a06fdbe4d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_review_likes
    ADD CONSTRAINT fk_rails_9a06fdbe4d FOREIGN KEY (vendor_review_id) REFERENCES public.vendor_reviews(id);


--
-- Name: vendor_reviews fk_rails_c98e35f83d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_reviews
    ADD CONSTRAINT fk_rails_c98e35f83d FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: connection_requests fk_rails_dc12e4e96c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connection_requests
    ADD CONSTRAINT fk_rails_dc12e4e96c FOREIGN KEY (initiator_service_posting_id) REFERENCES public.service_postings(id);


--
-- Name: connection_requests fk_rails_e92c2df04e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connection_requests
    ADD CONSTRAINT fk_rails_e92c2df04e FOREIGN KEY (initiator_id) REFERENCES public.users(id);


--
-- Name: connection_requests fk_rails_f29c2b3e20; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connection_requests
    ADD CONSTRAINT fk_rails_f29c2b3e20 FOREIGN KEY (receiver_service_posting_id) REFERENCES public.service_postings(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180604215450'),
('20180604215919'),
('20180607180116'),
('20180607181909'),
('20180607183018'),
('20180607184034'),
('20180614020506'),
('20180618203539'),
('20180618204016'),
('20180622034412'),
('20180625052912'),
('20180626050055'),
('20180626054646'),
('20180626072158'),
('20180814174920'),
('20180815192051'),
('20180821014923'),
('20180821174547'),
('20180822222701'),
('20180823042412'),
('20180826002434');


