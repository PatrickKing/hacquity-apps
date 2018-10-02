SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.admins (
    id bigint NOT NULL,
    name character varying,
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
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bulk_update_line_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.bulk_update_line_items (
    id bigint NOT NULL,
    bulk_update_record_id bigint,
    filename character varying,
    email character varying,
    status character varying,
    error_message character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bulk_update_line_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bulk_update_line_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bulk_update_line_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bulk_update_line_items_id_seq OWNED BY public.bulk_update_line_items.id;


--
-- Name: bulk_update_records; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.bulk_update_records (
    id bigint NOT NULL,
    status character varying,
    s3_zip_id character varying,
    admin_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    error_message character varying
);


--
-- Name: bulk_update_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bulk_update_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bulk_update_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bulk_update_records_id_seq OWNED BY public.bulk_update_records.id;


--
-- Name: connection_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: connections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: mentor_match_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
    available_ongoing boolean,
    available_email_questions boolean,
    available_one_off_meetings boolean,
    career_stage character varying,
    user_keywords character varying,
    user_keywords_gdoc_id character varying,
    mentorship_opportunities boolean,
    mentorship_promotion_tenure boolean,
    mentorship_career_life_balance boolean,
    mentorship_performance boolean,
    mentorship_networking boolean,
    career_track_research boolean,
    career_track_education boolean,
    career_track_policy boolean,
    career_track_leadership_admin boolean,
    career_track_clinical boolean,
    original_cv_mime_type character varying,
    original_cv_file_name character varying,
    personal_information character varying
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: service_postings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
    mentor_match_enabled boolean,
    subscribe_to_emails boolean,
    unsubscribe_token character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    preferred_contact_method character varying,
    phone_number character varying,
    admin_assistant_name character varying,
    admin_assistant_email character varying,
    admin_assistant_phone_number character varying,
    cv_receipt_token character varying,
    admin_approved timestamp without time zone,
    admin_disabled timestamp without time zone
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
-- Name: vendor_review_likes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: vendor_reviews; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_update_line_items ALTER COLUMN id SET DEFAULT nextval('public.bulk_update_line_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_update_records ALTER COLUMN id SET DEFAULT nextval('public.bulk_update_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connection_requests ALTER COLUMN id SET DEFAULT nextval('public.connection_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connections ALTER COLUMN id SET DEFAULT nextval('public.connections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs ALTER COLUMN id SET DEFAULT nextval('public.delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_match_profiles ALTER COLUMN id SET DEFAULT nextval('public.mentor_match_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_postings ALTER COLUMN id SET DEFAULT nextval('public.service_postings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_review_likes ALTER COLUMN id SET DEFAULT nextval('public.vendor_review_likes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_reviews ALTER COLUMN id SET DEFAULT nextval('public.vendor_reviews_id_seq'::regclass);


--
-- Name: admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: bulk_update_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.bulk_update_line_items
    ADD CONSTRAINT bulk_update_line_items_pkey PRIMARY KEY (id);


--
-- Name: bulk_update_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.bulk_update_records
    ADD CONSTRAINT bulk_update_records_pkey PRIMARY KEY (id);


--
-- Name: connection_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.connection_requests
    ADD CONSTRAINT connection_requests_pkey PRIMARY KEY (id);


--
-- Name: connections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.connections
    ADD CONSTRAINT connections_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: mentor_match_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.mentor_match_profiles
    ADD CONSTRAINT mentor_match_profiles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: service_postings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.service_postings
    ADD CONSTRAINT service_postings_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vendor_review_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.vendor_review_likes
    ADD CONSTRAINT vendor_review_likes_pkey PRIMARY KEY (id);


--
-- Name: vendor_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.vendor_reviews
    ADD CONSTRAINT vendor_reviews_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_priority ON public.delayed_jobs USING btree (priority, run_at);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_email ON public.admins USING btree (email);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON public.admins USING btree (reset_password_token);


--
-- Name: index_admins_on_unlock_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_unlock_token ON public.admins USING btree (unlock_token);


--
-- Name: index_bulk_update_line_items_on_bulk_update_record_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bulk_update_line_items_on_bulk_update_record_id ON public.bulk_update_line_items USING btree (bulk_update_record_id);


--
-- Name: index_bulk_update_records_on_admin_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bulk_update_records_on_admin_id ON public.bulk_update_records USING btree (admin_id);


--
-- Name: index_connection_requests_on_initiator_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_connection_requests_on_initiator_id ON public.connection_requests USING btree (initiator_id);


--
-- Name: index_connection_requests_on_initiator_service_posting_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_connection_requests_on_initiator_service_posting_id ON public.connection_requests USING btree (initiator_service_posting_id);


--
-- Name: index_connection_requests_on_receiver_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_connection_requests_on_receiver_id ON public.connection_requests USING btree (receiver_id);


--
-- Name: index_connection_requests_on_receiver_service_posting_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_connection_requests_on_receiver_service_posting_id ON public.connection_requests USING btree (receiver_service_posting_id);


--
-- Name: index_connections_on_first_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_connections_on_first_user_id ON public.connections USING btree (first_user_id);


--
-- Name: index_connections_on_second_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_connections_on_second_user_id ON public.connections USING btree (second_user_id);


--
-- Name: index_mentor_match_profiles_on_original_cv_drive_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mentor_match_profiles_on_original_cv_drive_id ON public.mentor_match_profiles USING btree (original_cv_drive_id);


--
-- Name: index_mentor_match_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mentor_match_profiles_on_user_id ON public.mentor_match_profiles USING btree (user_id);


--
-- Name: index_mentor_match_profiles_on_user_keywords_gdoc_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mentor_match_profiles_on_user_keywords_gdoc_id ON public.mentor_match_profiles USING btree (user_keywords_gdoc_id);


--
-- Name: index_service_postings_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_service_postings_on_user_id ON public.service_postings USING btree (user_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON public.users USING btree (unlock_token);


--
-- Name: index_users_on_unsubscribe_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_unsubscribe_token ON public.users USING btree (unsubscribe_token);


--
-- Name: index_vendor_review_likes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vendor_review_likes_on_user_id ON public.vendor_review_likes USING btree (user_id);


--
-- Name: index_vendor_review_likes_on_vendor_review_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vendor_review_likes_on_vendor_review_id ON public.vendor_review_likes USING btree (vendor_review_id);


--
-- Name: index_vendor_reviews_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vendor_reviews_on_user_id ON public.vendor_reviews USING btree (user_id);


--
-- Name: vendor_reviews_fts_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX vendor_reviews_fts_idx ON public.vendor_reviews USING gin (text_search_document);


--
-- Name: vendor_reviews_fts_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER vendor_reviews_fts_update BEFORE INSERT OR UPDATE ON public.vendor_reviews FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('text_search_document', 'pg_catalog.english', 'title', 'body', 'vendor_name', 'vendor_services');


--
-- Name: fk_rails_14b982e77e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connection_requests
    ADD CONSTRAINT fk_rails_14b982e77e FOREIGN KEY (receiver_id) REFERENCES public.users(id);


--
-- Name: fk_rails_343bc8bf08; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_review_likes
    ADD CONSTRAINT fk_rails_343bc8bf08 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_83fdfd96aa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_update_records
    ADD CONSTRAINT fk_rails_83fdfd96aa FOREIGN KEY (admin_id) REFERENCES public.admins(id);


--
-- Name: fk_rails_8a85be6f1c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_match_profiles
    ADD CONSTRAINT fk_rails_8a85be6f1c FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_8d397dd579; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_postings
    ADD CONSTRAINT fk_rails_8d397dd579 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_9a06fdbe4d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_review_likes
    ADD CONSTRAINT fk_rails_9a06fdbe4d FOREIGN KEY (vendor_review_id) REFERENCES public.vendor_reviews(id);


--
-- Name: fk_rails_c98e35f83d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_reviews
    ADD CONSTRAINT fk_rails_c98e35f83d FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_d37f9dccb1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_update_line_items
    ADD CONSTRAINT fk_rails_d37f9dccb1 FOREIGN KEY (bulk_update_record_id) REFERENCES public.bulk_update_records(id);


--
-- Name: fk_rails_dc12e4e96c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connection_requests
    ADD CONSTRAINT fk_rails_dc12e4e96c FOREIGN KEY (initiator_service_posting_id) REFERENCES public.service_postings(id);


--
-- Name: fk_rails_e92c2df04e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connection_requests
    ADD CONSTRAINT fk_rails_e92c2df04e FOREIGN KEY (initiator_id) REFERENCES public.users(id);


--
-- Name: fk_rails_f29c2b3e20; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connection_requests
    ADD CONSTRAINT fk_rails_f29c2b3e20 FOREIGN KEY (receiver_service_posting_id) REFERENCES public.service_postings(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

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
('20180826002434'),
('20180904012405'),
('20180906003800'),
('20180906045006'),
('20180907190433'),
('20180910212602'),
('20180911043715'),
('20180918055137'),
('20180919203142'),
('20180921224548'),
('20180925000743'),
('20180926203231'),
('20180926203753'),
('20180928214116');


