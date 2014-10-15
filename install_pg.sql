--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.14
-- Dumped by pg_dump version 9.1.14
-- Started on 2014-10-14 10:03:00 EEST

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 189 (class 3079 OID 11685)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2081 (class 0 OID 0)
-- Dependencies: 189
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 201 (class 1255 OID 34877)
-- Dependencies: 578 5
-- Name: update_content_date_from_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_content_date_from_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.content_date_from = now(); 
   RETURN NEW;
END;
$$;


--
-- TOC entry 203 (class 1255 OID 34983)
-- Dependencies: 5 578
-- Name: update_date_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_date_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.date = now(); 
   RETURN NEW;
END;
$$;


--
-- TOC entry 202 (class 1255 OID 34940)
-- Dependencies: 578 5
-- Name: update_news_date_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_news_date_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.news_date = now(); 
   RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 162 (class 1259 OID 34823)
-- Dependencies: 1882 5
-- Name: base_calls; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_calls (
    calls_id integer NOT NULL,
    user_id integer NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    user_id_to integer NOT NULL,
    number character varying(32) NOT NULL
);


--
-- TOC entry 161 (class 1259 OID 34821)
-- Dependencies: 162 5
-- Name: base_calls_calls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE base_calls_calls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2082 (class 0 OID 0)
-- Dependencies: 161
-- Name: base_calls_calls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE base_calls_calls_id_seq OWNED BY base_calls.calls_id;


--
-- TOC entry 166 (class 1259 OID 34846)
-- Dependencies: 1888 1889 1890 1891 5
-- Name: base_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_comments (
    comment_id integer NOT NULL,
    user_id integer,
    lang character varying(2) NOT NULL,
    comment_type character varying(1) DEFAULT NULL::character varying,
    comment_url character varying(512) DEFAULT NULL::character varying,
    comment_body character varying(128) DEFAULT NULL::character varying,
    comment_position double precision,
    comment_private character varying(1) DEFAULT NULL::character varying
);


--
-- TOC entry 165 (class 1259 OID 34844)
-- Dependencies: 5 166
-- Name: base_comments_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE base_comments_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2083 (class 0 OID 0)
-- Dependencies: 165
-- Name: base_comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE base_comments_comment_id_seq OWNED BY base_comments.comment_id;


--
-- TOC entry 168 (class 1259 OID 34866)
-- Dependencies: 1893 1894 5
-- Name: base_content; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_content (
    content_id integer NOT NULL,
    user_id integer NOT NULL,
    content_page character varying(512) NOT NULL,
    lang character varying(2) NOT NULL,
    content_date_from timestamp without time zone DEFAULT now() NOT NULL,
    content_title text,
    content_body text,
    content_place character varying(64) DEFAULT NULL::character varying
);


--
-- TOC entry 167 (class 1259 OID 34864)
-- Dependencies: 168 5
-- Name: base_content_content_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE base_content_content_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2084 (class 0 OID 0)
-- Dependencies: 167
-- Name: base_content_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE base_content_content_id_seq OWNED BY base_content.content_id;


--
-- TOC entry 170 (class 1259 OID 34881)
-- Dependencies: 1896 5
-- Name: base_gallery; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_gallery (
    gal_id integer NOT NULL,
    gal_name bytea NOT NULL,
    gal_description bytea NOT NULL,
    lang character varying(2) DEFAULT NULL::character varying,
    gal_key integer NOT NULL
);


--
-- TOC entry 169 (class 1259 OID 34879)
-- Dependencies: 170 5
-- Name: base_gallery_gal_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE base_gallery_gal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2085 (class 0 OID 0)
-- Dependencies: 169
-- Name: base_gallery_gal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE base_gallery_gal_id_seq OWNED BY base_gallery.gal_id;


--
-- TOC entry 172 (class 1259 OID 34893)
-- Dependencies: 1898 5
-- Name: base_gallery_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_gallery_images (
    img_id integer NOT NULL,
    img_name character varying(45) DEFAULT NULL::character varying,
    img_order integer,
    gal_key integer
);


--
-- TOC entry 171 (class 1259 OID 34891)
-- Dependencies: 5 172
-- Name: base_gallery_images_img_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE base_gallery_images_img_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2086 (class 0 OID 0)
-- Dependencies: 171
-- Name: base_gallery_images_img_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE base_gallery_images_img_id_seq OWNED BY base_gallery_images.img_id;


--
-- TOC entry 176 (class 1259 OID 34913)
-- Dependencies: 1901 5
-- Name: base_menu; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_menu (
    menu_id integer NOT NULL,
    menu_name bytea,
    lang character varying(2) DEFAULT NULL::character varying,
    menu_key integer
);


--
-- TOC entry 175 (class 1259 OID 34911)
-- Dependencies: 176 5
-- Name: base_menu_menu_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE base_menu_menu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2087 (class 0 OID 0)
-- Dependencies: 175
-- Name: base_menu_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE base_menu_menu_id_seq OWNED BY base_menu.menu_id;


--
-- TOC entry 174 (class 1259 OID 34902)
-- Dependencies: 5
-- Name: base_menu_url; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_menu_url (
    menu_key integer NOT NULL,
    menu_url bytea,
    menu_parent integer,
    menu_order integer
);


--
-- TOC entry 173 (class 1259 OID 34900)
-- Dependencies: 5 174
-- Name: base_menu_url_menu_key_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE base_menu_url_menu_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2088 (class 0 OID 0)
-- Dependencies: 173
-- Name: base_menu_url_menu_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE base_menu_url_menu_key_seq OWNED BY base_menu_url.menu_key;


--
-- TOC entry 178 (class 1259 OID 34930)
-- Dependencies: 1903 5
-- Name: base_news; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_news (
    news_id integer NOT NULL,
    news_date timestamp without time zone DEFAULT now() NOT NULL,
    lang character varying(2) NOT NULL,
    news_name bytea NOT NULL,
    news_body bytea NOT NULL,
    news_key integer NOT NULL
);


--
-- TOC entry 177 (class 1259 OID 34928)
-- Dependencies: 178 5
-- Name: base_news_news_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE base_news_news_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2089 (class 0 OID 0)
-- Dependencies: 177
-- Name: base_news_news_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE base_news_news_id_seq OWNED BY base_news.news_id;


--
-- TOC entry 164 (class 1259 OID 34832)
-- Dependencies: 1884 1885 1886 5
-- Name: base_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_users (
    user_id integer NOT NULL,
    user_login character varying(255) NOT NULL,
    user_password character varying(64) NOT NULL,
    user_email character varying(128) DEFAULT ''::character varying,
    user_name character varying(255) NOT NULL,
    user_lang character varying(2) DEFAULT ''::character varying,
    group_id integer DEFAULT 1 NOT NULL
);


--
-- TOC entry 180 (class 1259 OID 34944)
-- Dependencies: 5
-- Name: base_users_config; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_users_config (
    config_id integer NOT NULL,
    user_id integer NOT NULL,
    config_name character varying(64) NOT NULL,
    config_value character varying(512) NOT NULL
);


--
-- TOC entry 179 (class 1259 OID 34942)
-- Dependencies: 5 180
-- Name: base_users_config_config_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE base_users_config_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2090 (class 0 OID 0)
-- Dependencies: 179
-- Name: base_users_config_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE base_users_config_config_id_seq OWNED BY base_users_config.config_id;


--
-- TOC entry 182 (class 1259 OID 34955)
-- Dependencies: 5
-- Name: base_users_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_users_groups (
    group_id integer NOT NULL,
    group_name character varying(64) NOT NULL
);


--
-- TOC entry 184 (class 1259 OID 34963)
-- Dependencies: 5
-- Name: base_users_groups_access; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_users_groups_access (
    access_id integer NOT NULL,
    group_id integer NOT NULL,
    access_name character varying(128) NOT NULL
);


--
-- TOC entry 183 (class 1259 OID 34961)
-- Dependencies: 184 5
-- Name: base_users_groups_access_access_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE base_users_groups_access_access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2091 (class 0 OID 0)
-- Dependencies: 183
-- Name: base_users_groups_access_access_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE base_users_groups_access_access_id_seq OWNED BY base_users_groups_access.access_id;


--
-- TOC entry 181 (class 1259 OID 34953)
-- Dependencies: 182 5
-- Name: base_users_groups_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE base_users_groups_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2092 (class 0 OID 0)
-- Dependencies: 181
-- Name: base_users_groups_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE base_users_groups_group_id_seq OWNED BY base_users_groups.group_id;


--
-- TOC entry 186 (class 1259 OID 34976)
-- Dependencies: 1908 5
-- Name: base_users_recover; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_users_recover (
    user_id integer NOT NULL,
    recover character varying(64) NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 185 (class 1259 OID 34974)
-- Dependencies: 5 186
-- Name: base_users_recover_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE base_users_recover_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2093 (class 0 OID 0)
-- Dependencies: 185
-- Name: base_users_recover_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE base_users_recover_user_id_seq OWNED BY base_users_recover.user_id;


--
-- TOC entry 188 (class 1259 OID 34987)
-- Dependencies: 5
-- Name: base_users_settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_users_settings (
    setting_id integer NOT NULL,
    user_id integer NOT NULL,
    setting_name character varying(64) NOT NULL,
    setting_value character varying(512) NOT NULL
);


--
-- TOC entry 187 (class 1259 OID 34985)
-- Dependencies: 188 5
-- Name: base_users_settings_setting_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE base_users_settings_setting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2094 (class 0 OID 0)
-- Dependencies: 187
-- Name: base_users_settings_setting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE base_users_settings_setting_id_seq OWNED BY base_users_settings.setting_id;


--
-- TOC entry 163 (class 1259 OID 34830)
-- Dependencies: 164 5
-- Name: base_users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE base_users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2095 (class 0 OID 0)
-- Dependencies: 163
-- Name: base_users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE base_users_user_id_seq OWNED BY base_users.user_id;


--
-- TOC entry 1881 (class 2604 OID 34826)
-- Dependencies: 161 162 162
-- Name: calls_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_calls ALTER COLUMN calls_id SET DEFAULT nextval('base_calls_calls_id_seq'::regclass);


--
-- TOC entry 1887 (class 2604 OID 34849)
-- Dependencies: 165 166 166
-- Name: comment_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_comments ALTER COLUMN comment_id SET DEFAULT nextval('base_comments_comment_id_seq'::regclass);


--
-- TOC entry 1892 (class 2604 OID 34869)
-- Dependencies: 168 167 168
-- Name: content_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_content ALTER COLUMN content_id SET DEFAULT nextval('base_content_content_id_seq'::regclass);


--
-- TOC entry 1895 (class 2604 OID 34884)
-- Dependencies: 170 169 170
-- Name: gal_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_gallery ALTER COLUMN gal_id SET DEFAULT nextval('base_gallery_gal_id_seq'::regclass);


--
-- TOC entry 1897 (class 2604 OID 34896)
-- Dependencies: 172 171 172
-- Name: img_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_gallery_images ALTER COLUMN img_id SET DEFAULT nextval('base_gallery_images_img_id_seq'::regclass);


--
-- TOC entry 1900 (class 2604 OID 34916)
-- Dependencies: 175 176 176
-- Name: menu_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_menu ALTER COLUMN menu_id SET DEFAULT nextval('base_menu_menu_id_seq'::regclass);


--
-- TOC entry 1899 (class 2604 OID 34905)
-- Dependencies: 174 173 174
-- Name: menu_key; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_menu_url ALTER COLUMN menu_key SET DEFAULT nextval('base_menu_url_menu_key_seq'::regclass);


--
-- TOC entry 1902 (class 2604 OID 34933)
-- Dependencies: 177 178 178
-- Name: news_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_news ALTER COLUMN news_id SET DEFAULT nextval('base_news_news_id_seq'::regclass);


--
-- TOC entry 1883 (class 2604 OID 34835)
-- Dependencies: 163 164 164
-- Name: user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_users ALTER COLUMN user_id SET DEFAULT nextval('base_users_user_id_seq'::regclass);


--
-- TOC entry 1904 (class 2604 OID 34947)
-- Dependencies: 180 179 180
-- Name: config_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_users_config ALTER COLUMN config_id SET DEFAULT nextval('base_users_config_config_id_seq'::regclass);


--
-- TOC entry 1905 (class 2604 OID 34958)
-- Dependencies: 182 181 182
-- Name: group_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_users_groups ALTER COLUMN group_id SET DEFAULT nextval('base_users_groups_group_id_seq'::regclass);


--
-- TOC entry 1906 (class 2604 OID 34966)
-- Dependencies: 184 183 184
-- Name: access_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_users_groups_access ALTER COLUMN access_id SET DEFAULT nextval('base_users_groups_access_access_id_seq'::regclass);


--
-- TOC entry 1907 (class 2604 OID 34979)
-- Dependencies: 186 185 186
-- Name: user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_users_recover ALTER COLUMN user_id SET DEFAULT nextval('base_users_recover_user_id_seq'::regclass);


--
-- TOC entry 1909 (class 2604 OID 34990)
-- Dependencies: 188 187 188
-- Name: setting_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_users_settings ALTER COLUMN setting_id SET DEFAULT nextval('base_users_settings_setting_id_seq'::regclass);


--
-- TOC entry 2047 (class 0 OID 34823)
-- Dependencies: 162 2074
-- Data for Name: base_calls; Type: TABLE DATA; Schema: public; Owner: -
--

COPY base_calls (calls_id, user_id, date, user_id_to, number) FROM stdin;
\.


--
-- TOC entry 2096 (class 0 OID 0)
-- Dependencies: 161
-- Name: base_calls_calls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('base_calls_calls_id_seq', 1, false);


--
-- TOC entry 2051 (class 0 OID 34846)
-- Dependencies: 166 2074
-- Data for Name: base_comments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY base_comments (comment_id, user_id, lang, comment_type, comment_url, comment_body, comment_position, comment_private) FROM stdin;
\.


--
-- TOC entry 2097 (class 0 OID 0)
-- Dependencies: 165
-- Name: base_comments_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('base_comments_comment_id_seq', 1, false);


--
-- TOC entry 2053 (class 0 OID 34866)
-- Dependencies: 168 2074
-- Data for Name: base_content; Type: TABLE DATA; Schema: public; Owner: -
--

COPY base_content (content_id, user_id, content_page, lang, content_date_from, content_title, content_body, content_place) FROM stdin;
2345	0	/contacts	en	2012-12-08 12:50:56	Contact Us	\\r\\n<h2>\\r\\n\tContact Us</h2>\\r\\n<p>\\r\\n\t<strong>phone:</strong> 0038-066-938-1344</p>\\r\\n<p>\\r\\n\t<strong>e-mail:</strong> <a href=\\"mailto:2@ivanoff.org.ua\\">2@ivanoff.org.ua</a></p>\\r\\n<p>\\r\\n\t&nbsp;</p>\\r\\n<h2>\\r\\n\tFeedback</h2>{contacts/index}\\r\\n	\N
10589	0	_header	en	2013-07-15 17:23:17	\N	<h1><font color=\\"#cc0000\\"><img alt=\\"\\" src=\\"/images/gallery/logo_small.gif\\" style=\\"width: 81px; height: 60px; vertical-align: middle\\">Simpleness CMS<br></font></h1>	\N
10731	0		en	2013-07-15 20:30:16	\N	<h2>First of all, Simpleness...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS - is an open-source Perl CMS system.</strong><br>The basic principle of the system - the simpler, the better. <a href=\\"http://cms.simpleness.org/about\\">Find out more</a>.</p><br>Last version - 0.36 was released on July 15. You can download this system from <a href=\\"http://cms.simpleness.org/download\\">this page</a>.\\n<p><br>Waiting for your comments about idea and code. If you wish to participate in development - please <a href=\\"http://cms.simpleness.org/contacts\\">contact me</a>.</p>	\N
10733	0		ua	2013-07-15 20:30:16	\N	<h2>Ð’ Ð¿ÐµÑ€ÑˆÑƒ Ñ‡ÐµÑ€Ð³Ñƒ, Ð¿Ñ€Ð¾ÑÑ‚Ð¾Ñ‚Ð° ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>ÐŸÑ€Ð¾ÑÑ‚Ð¾Ñ‚Ð° CMS - Ñ†Ðµ Ð· Ð²Ñ–Ð´ÐºÑ€Ð¸Ñ‚Ð¸Ð¼ Ð²Ð¸Ñ…Ñ–Ð´Ð½Ð¸Ð¼ ÐºÐ¾Ð´Ð¾Ð¼ Perl CMS ÑÐ¸ÑÑ‚ÐµÐ¼Ð¸.</strong><br>ÐžÑÐ½Ð¾Ð²Ð½Ð¸Ð¹ Ð¿Ñ€Ð¸Ð½Ñ†Ð¸Ð¿ ÑÐ¸ÑÑ‚ÐµÐ¼Ð¸ - Ð¿Ñ€Ð¾ÑÑ‚Ñ–ÑˆÐµ, Ñ‚Ð¸Ð¼ ÐºÑ€Ð°Ñ‰Ðµ. <a href=\\"http://cms.simpleness.org/about\\">Ð”Ñ–Ð·Ð½Ð°Ð¹Ñ‚ÐµÑÑ Ð±Ñ–Ð»ÑŒÑˆÐµ</a>.</p><br>ÐžÑÑ‚Ð°Ð½Ð½Ñ Ð²ÐµÑ€ÑÑ–Ñ - 0.36 Ð±ÑƒÐ»Ð° Ð²Ð¸Ð¿ÑƒÑ‰ÐµÐ½Ð° 15 Ð»Ð¸Ð¿Ð½Ñ. Ð’Ð¸ Ð¼Ð¾Ð¶ÐµÑ‚Ðµ Ð·Ð°Ð²Ð°Ð½Ñ‚Ð°Ð¶Ð¸Ñ‚Ð¸ Ñ†ÑŽ ÑÐ¸ÑÑ‚ÐµÐ¼Ñƒ Ð· <a href=\\"http://cms.simpleness.org/download\\">Ñ†ÑŽ ÑÑ‚Ð¾Ñ€Ñ–Ð½ÐºÑƒ</a>.\\n<p><br>Ð§ÐµÐºÐ°ÑŽ Ð²Ð°ÑˆÐ¸Ñ… ÐºÐ¾Ð¼ÐµÐ½Ñ‚Ð°Ñ€Ñ–Ð² Ð· Ð¿Ñ€Ð¸Ð²Ð¾Ð´Ñƒ Ñ–Ð´ÐµÑ— Ñ‚Ð° ÐºÐ¾Ð´Ñƒ. Ð¯ÐºÑ‰Ð¾ Ð²Ð¸ Ñ…Ð¾Ñ‡ÐµÑ‚Ðµ Ð²Ð·ÑÑ‚Ð¸ ÑƒÑ‡Ð°ÑÑ‚ÑŒ Ñƒ Ñ€Ð¾Ð·Ð²Ð¸Ñ‚ÐºÑƒ - Ð»Ð°ÑÐºÐ°, <a href=\\"http://cms.simpleness.org/contacts\\">Ð·Ð²&#39;ÑÐ·Ð°Ñ‚Ð¸ÑÑ Ð·Ñ– Ð¼Ð½Ð¾ÑŽ</a>.</p>	\N
10734	0		fr	2013-07-15 20:30:16	\N	<h2>Tout d&#39;abord, Simpleness ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS - est un systÃ¨me CMS open-source Perl.</strong><br>Le principe de base du systÃ¨me - la plus simple, mieux c&#39;est. <a href=\\"http://cms.simpleness.org/about\\">En savoir plus</a>.</p><br>DerniÃ¨re version - 0.36 a Ã©tÃ© libÃ©rÃ© le 15 Juillet. Vous pouvez tÃ©lÃ©charger ce systÃ¨me de <a href=\\"http://cms.simpleness.org/download\\">cette page</a>.\\n<p><br>En attente de vos commentaires Ã  propos de l&#39;idÃ©e et le code. Si vous souhaitez participer au dÃ©veloppement - s&#39;il vous plaÃ®t <a href=\\"http://cms.simpleness.org/contacts\\">me contacter</a>.</p>	\N
10735	0		de	2013-07-15 20:30:16	\N	<h2>ZunÃ¤chst Simpleness ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS - ist ein Open-Source-CMS-System Perl.</strong><br>Das Grundprinzip des Systems - Je einfacher, desto besser. <a href=\\"http://cms.simpleness.org/about\\">Erfahren Sie mehr</a>.</p><br>Neue Version - 0.36 wurde am 15. Juli verÃ¶ffentlicht. Sie kÃ¶nnen dieses System aus downloaden <a href=\\"http://cms.simpleness.org/download\\">diese Seite</a>.\\n<p><br>Warten auf Ihre Kommentare Ã¼ber Idee und Code. Wenn Sie in der Entwicklung beteiligen mÃ¶chten - bitte <a href=\\"http://cms.simpleness.org/contacts\\">Kontaktieren Sie mich</a>.</p>	\N
10736	0		es	2013-07-15 20:30:16	\N	<h2>En primer lugar, de Simpleness ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Sencillez CMS - es un sistema CMS de cÃ³digo abierto Perl.</strong><br>El principio bÃ¡sico del sistema - la mÃ¡s simple, mejor. <a href=\\"http://cms.simpleness.org/about\\">Para saber mÃ¡s</a>.</p><br>Ãšltima versiÃ³n - 0.36 fue lanzado el 15 de julio. Si deseas descargar este sistema desde <a href=\\"http://cms.simpleness.org/download\\">esta pÃ¡gina</a>.\\n<p><br>Esperando sus comentarios acerca de idea y el cÃ³digo. Si usted desea participar en el desarrollo - por favor <a href=\\"http://cms.simpleness.org/contacts\\">pÃ³ngase en contacto conmigo</a>.</p>	\N
10737	0		it	2013-07-15 20:30:16	\N	<h2>Prima di tutto, Simpleness ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS - Ã¨ un sistema CMS Perl open-source.</strong><br>Il principio di base del sistema - il semplice, meglio Ã¨. <a href=\\"http://cms.simpleness.org/about\\">Per saperne di piÃ¹</a>.</p><br>Ultima versione - 0.36 Ã¨ stato rilasciato il 15 luglio. Ãˆ possibile scaricare questo sistema da <a href=\\"http://cms.simpleness.org/download\\">questa pagina</a>.\\n<p><br>In attesa di vostri commenti su idea e il codice. Se si desidera partecipare allo sviluppo - si prega di <a href=\\"http://cms.simpleness.org/contacts\\">contattarmi</a>.</p>	\N
10738	0		gr	2013-07-15 20:30:16	\N	<h2>Î ÏÏŽÏ„Î± Î±Ï€ÏŒ ÏŒÎ»Î±, Î±Ï€Î»ÏŒÏ„Î·Ï„Î± ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS - ÎµÎ¯Î½Î±Î¹ Î­Î½Î± open-source Perl CMS ÏƒÏÏƒÏ„Î·Î¼Î±.</strong><br>Î— Î²Î±ÏƒÎ¹ÎºÎ® Î±ÏÏ‡Î® Ï„Î¿Ï… ÏƒÏ…ÏƒÏ„Î®Î¼Î±Ï„Î¿Ï‚ - Ï„Î¿ Î±Ï€Î»Î¿ÏÏƒÏ„ÎµÏÎ¿, Ï„ÏŒÏƒÎ¿ Ï„Î¿ ÎºÎ±Î»ÏÏ„ÎµÏÎ¿. <a href=\\"http://cms.simpleness.org/about\\">ÎœÎ¬Î¸ÎµÏ„Îµ Ï€ÎµÏÎ¹ÏƒÏƒÏŒÏ„ÎµÏÎ±</a>.</p><br>Î¤ÎµÎ»ÎµÏ…Ï„Î±Î¯Î± Î­ÎºÎ´Î¿ÏƒÎ· - 0.36 ÎºÏ…ÎºÎ»Î¿Ï†ÏŒÏÎ·ÏƒÎµ ÏƒÏ„Î¹Ï‚ 15 Î™Î¿Ï…Î»Î¯Î¿Ï…. ÎœÏ€Î¿ÏÎµÎ¯Ï„Îµ Î½Î± ÎºÎ±Ï„ÎµÎ²Î¬ÏƒÎµÏ„Îµ Î±Ï…Ï„ÏŒ Ï„Î¿ ÏƒÏÏƒÏ„Î·Î¼Î± Î±Ï€ÏŒ <a href=\\"http://cms.simpleness.org/download\\">Î±Ï…Ï„Î® Ï„Î· ÏƒÎµÎ»Î¯Î´Î±</a>.\\n<p><br>Î‘Î½Î±Î¼Î¿Î½Î® Î³Î¹Î± Ï„Î± ÏƒÏ‡ÏŒÎ»Î¹Î¬ ÏƒÎ±Ï‚ ÏƒÏ‡ÎµÏ„Î¹ÎºÎ¬ Î¼Îµ Ï„Î·Î½ Î¹Î´Î­Î± ÎºÎ±Î¹ Ï„Î¿Î½ ÎºÏ‰Î´Î¹ÎºÏŒ. Î•Î¬Î½ ÎµÏ€Î¹Î¸Ï…Î¼ÎµÎ¯Ï„Îµ Î½Î± ÏƒÏ…Î¼Î¼ÎµÏ„Î¬ÏƒÏ‡ÎµÏ„Îµ ÏƒÏ„Î·Î½ Î±Î½Î¬Ï€Ï„Ï…Î¾Î· - Ï€Î±ÏÎ±ÎºÎ±Î»ÏŽ <a href=\\"http://cms.simpleness.org/contacts\\">ÎµÏ€Î¹ÎºÎ¿Î¹Î½Ï‰Î½Î®ÏƒÏ„Îµ Î¼Î±Î¶Î¯ Î¼Î¿Ï…</a>.</p>	\N
10739	0		ch	2013-07-15 20:30:16	\N	<h2>é¦–å…ˆï¼Œç®€å•...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS  - æ˜¯ä¸€ä¸ªå¼€æºçš„Perlçš„CMSç³»ç»Ÿã€‚</strong><br>è¯¥ç³»ç»Ÿçš„åŸºæœ¬åŽŸç† - ç®€å•è¶Šå¥½ã€‚ <a href=\\"http://cms.simpleness.org/about\\">äº†è§£æ›´å¤š</a>.</p><br>7æœˆ15æ—¥å‘å¸ƒäº†æœ€æ–°ç‰ˆæœ¬ -  0.36ã€‚æ‚¨å¯ä»¥ä¸‹è½½è¿™ä¸ªç³»ç»Ÿ <a href=\\"http://cms.simpleness.org/download\\">æ­¤é¡µ</a>.\\n<p><br>ç­‰å¾…ä½ çš„çœ‹æ³•æƒ³æ³•å’Œä»£ç ã€‚å¦‚æžœä½ æƒ³å‚ä¸Žå‘å±• - è¯· <a href=\\"http://cms.simpleness.org/contacts\\">ä¸Žæˆ‘è”ç³»</a>.</p>	\N
10740	0		jp	2013-07-15 20:30:16	\N	<h2>ã¾ãšç¬¬ä¸€ã«ã€ã‚·ãƒ³ãƒ—ãƒ«ã•...</h2>\\n<p>&nbsp;</p>\\n<p><strong>ã‚·ãƒ³ãƒ—ãƒ«ã•ã¯ã€CMS  - ã‚ªãƒ¼ãƒ—ãƒ³ã‚½ãƒ¼ã‚¹ã®Perlã®CMSã‚·ã‚¹ãƒ†ãƒ ã§ã™ã€‚</strong><br>ã‚·ã‚¹ãƒ†ãƒ ã®åŸºæœ¬åŽŸç† - ã‚·ãƒ³ãƒ—ãƒ«ã§è‰¯ã„ã€‚ <a href=\\"http://cms.simpleness.org/about\\">è©³ç´°ã‚’ã”è¦§ãã ã•ã„</a>.</p><br>æœ€å¾Œã®ãƒãƒ¼ã‚¸ãƒ§ãƒ³ -  0.36ãŒ7æœˆ15æ—¥ã«ãƒªãƒªãƒ¼ã‚¹ã•ã‚Œã¾ã—ãŸã€‚ã“ã®ã‚·ã‚¹ãƒ†ãƒ ã‹ã‚‰ãƒ€ã‚¦ãƒ³ãƒ­ãƒ¼ãƒ‰ã§ãã¾ã™ <a href=\\"http://cms.simpleness.org/download\\">ã“ã®ãƒšãƒ¼ã‚¸</a>.\\n<p><br>ã‚¢ã‚¤ãƒ‡ã‚¢ã¨ã‚³ãƒ¼ãƒ‰ã«ã¤ã„ã¦ã®ã‚³ãƒ¡ãƒ³ãƒˆã‚’å¾…ã£ã¦ã„ã¾ã™ã€‚ã‚ãªãŸãŒé–‹ç™ºã«å‚åŠ ã—ãŸã„å ´åˆã¯ - ã—ã¦ãã ã•ã„ <a href=\\"http://cms.simpleness.org/contacts\\">ç§ã«é€£çµ¡ã—</a>.</p>	\N
10741	0		tr	2013-07-15 20:30:16	\N	<h2>Her ÅŸeyden Ã¶nce, Sadelik ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS - bir aÃ§Ä±k kaynak Perl CMS sistemidir.</strong><br>Sistemin temel ilke -, basit iyi. <a href=\\"http://cms.simpleness.org/about\\">Daha fazla bilgi</a>.</p><br>Son sÃ¼rÃ¼m - 0.36 15 Temmuz&#39;da serbest bÄ±rakÄ±ldÄ±. Sizden bu sistem indirebilirsiniz <a href=\\"http://cms.simpleness.org/download\\">Bu sayfayÄ±</a>.\\n<p><br>Fikir ve kod ile ilgili gÃ¶rÃ¼ÅŸ bekliyorum. EÄŸer geliÅŸtirme katÄ±lmak isterseniz - lÃ¼tfen <a href=\\"http://cms.simpleness.org/contacts\\">bana ulaÅŸÄ±n</a>.</p>	\N
10742	0		ar	2013-07-15 20:30:16	\N	<h2>Ø¨Ø§Ø¯Ø¦ Ø°ÙŠ Ø¨Ø¯Ø¡ØŒ Ø§Ù„Ø¨Ø³Ø§Ø·Ø© ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Ø§Ù„Ø¨Ø³Ø§Ø·Ù‡ CMS - Ù‡Ùˆ Ù…ÙØªÙˆØ­ Ø§Ù„Ù…ØµØ¯Ø± Ø¨ÙŠØ±Ù„ Ù†Ø¸Ø§Ù… CMS.</strong><br>Ø§Ù„Ù…Ø¨Ø¯Ø£ Ø§Ù„Ø£Ø³Ø§Ø³ÙŠ Ù„Ù„Ù†Ø¸Ø§Ù… - Ø£Ø¨Ø³Ø·ØŒ ÙƒØ§Ù† Ø°Ù„Ùƒ Ø£ÙØ¶Ù„. <a href=\\"http://cms.simpleness.org/about\\">Ù…Ø¹Ø±ÙØ© Ø§Ù„Ù…Ø²ÙŠØ¯</a>.</p><br>ÙˆØ£Ø·Ù„Ù‚ Ø³Ø±Ø§Ø­ 0.36 ÙŠÙˆÙ… 15 ÙŠÙˆÙ„ÙŠÙˆ ØªÙ…ÙˆØ² - Ø§Ù„Ø¥ØµØ¯Ø§Ø± Ø§Ù„Ø£Ø®ÙŠØ±. ÙŠÙ…ÙƒÙ†Ùƒ ØªØ­Ù…ÙŠÙ„ Ù‡Ø°Ø§ Ø§Ù„Ù†Ø¸Ø§Ù… Ù…Ù† <a href=\\"http://cms.simpleness.org/download\\">Ù‡Ø°Ù‡ Ø§Ù„ØµÙØ­Ø©</a>.\\n<p><br>ÙÙŠ Ø§Ù†ØªØ¸Ø§Ø± ØªØ¹Ù„ÙŠÙ‚Ø§ØªÙƒÙ… Ø­ÙˆÙ„ ÙÙƒØ±Ø© ÙˆØ±Ù…Ø². Ø¥Ø°Ø§ ÙƒÙ†Øª ØªØ±ØºØ¨ ÙÙŠ Ø§Ù„Ù…Ø´Ø§Ø±ÙƒØ© ÙÙŠ Ø§Ù„ØªÙ†Ù…ÙŠØ© - Ù…Ù† ÙØ¶Ù„Ùƒ <a href=\\"http://cms.simpleness.org/contacts\\">Ø§Ù„Ø§ØªØµØ§Ù„ Ø¨ÙŠ</a>.</p>	\N
10743	0		fa	2013-07-15 20:30:16	\N	<h2>Ø§ÙˆÙ„ Ø§Ø² Ù‡Ù…Ù‡ØŒ Ø³Ø§Ø¯Ú¯&#1740; ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Ø³Ø§Ø¯Ú¯&#1740; Ø³&#1740;Ø³ØªÙ… Ù…Ø¯&#1740;Ø±&#1740;Øª Ù…Ø­ØªÙˆØ§ - Ø³&#1740;Ø³ØªÙ… Ù…Ø¯&#1740;Ø±&#1740;Øª Ù…Ø­ØªÙˆØ§ Ù¾Ø±Ù„ Ú©Ø¯ Ù…Ù†Ø¨Ø¹ Ø¨Ø§Ø² Ø§Ø³Øª.</strong><br>Ø§ØµÙ„ Ø§Ø³Ø§Ø³&#1740; Ø³&#1740;Ø³ØªÙ… - Ú†Ù‡ Ø³Ø§Ø¯Ù‡ ØªØ±ØŒ Ø¨Ù‡ØªØ±. <a href=\\"http://cms.simpleness.org/about\\">&#1740;Ø§ÙØªÙ† Ù¾Ø³Øª Ù‡Ø§&#1740; Ø¨&#1740;Ø´ØªØ±</a>.</p><br>Ø¢Ø®Ø±&#1740;Ù† Ù†Ø³Ø®Ù‡ - 0.36 Ø¯Ø± ØªØ§Ø±&#1740;Ø® 15 Ú˜ÙˆØ¦&#1740;Ù‡ Ù…Ù†ØªØ´Ø± Ø´Ø¯. Ø´Ù…Ø§ Ù…&#1740; ØªÙˆØ§Ù†&#1740;Ø¯ Ø§&#1740;Ù† Ø³&#1740;Ø³ØªÙ… Ø±Ø§ Ø§Ø² Ø¯Ø§Ù†Ù„ÙˆØ¯ Ú©Ù†&#1740;Ø¯ <a href=\\"http://cms.simpleness.org/download\\">Ø§&#1740;Ù† ØµÙØ­Ù‡</a>.\\n<p><br>Ø¯Ø± Ø§Ù†ØªØ¸Ø§Ø± Ù†Ø¸Ø± Ø®ÙˆØ¯ Ø±Ø§ Ø¯Ø± Ù…ÙˆØ±Ø¯ Ø§&#1740;Ø¯Ù‡ Ù‡Ø§ Ùˆ Ú©Ø¯. Ø§Ú¯Ø± Ø´Ù…Ø§ Ù…Ø§&#1740;Ù„ Ø¨Ù‡ Ù…Ø´Ø§Ø±Ú©Øª Ø¯Ø± ØªÙˆØ³Ø¹Ù‡ - Ù„Ø·ÙØ§ <a href=\\"http://cms.simpleness.org/contacts\\">ØªÙ…Ø§Ø³ Ø¨Ø§ Ù…Ù†</a>.</p>	\N
10744	0		il	2013-07-15 20:30:16	\N	<h2>×§×•×“× ×›×œ, simpleness ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS - ×”×•× ×ž×¢×¨×›×ª CMS ×¤×¨×œ ×‘×§×•×“ ×¤×ª×•×—×”.</strong><br>×”×¢×™×§×¨×•×Ÿ ×”×‘×¡×™×¡×™ ×©×œ ×”×ž×¢×¨×›×ª - ×¤×©×•×˜ ×™×•×ª×¨, ×˜×•×‘ ×™×•×ª×¨. <a href=\\"http://cms.simpleness.org/about\\">×œ×ž×™×“×¢ × ×•×¡×£</a>.</p><br>×”×’×¨×¡×” ×”××—×¨×•× ×” - 0.36 ×©×•×—×¨×¨×” ×‘ -15 ×‘×™×•×œ×™. ××ª×” ×™×›×•×œ ×œ×”×•×¨×™×“ ××ª ×–×” ×ž×ž×¢×¨×›×ª <a href=\\"http://cms.simpleness.org/download\\">×“×£ ×–×”</a>.\\n<p><br>×ž×—×›×” ×œ×”×¢×¨×•×ª ×©×œ×š ×¢×œ ×¨×¢×™×•×Ÿ ×•××ª ×”×§×•×“. ×× ×‘×¨×¦×•× ×š ×œ×”×©×ª×ª×£ ×‘×¤×™×ª×•×— - ×‘×‘×§×©×” <a href=\\"http://cms.simpleness.org/contacts\\">×¦×•×¨ ××™×ª×™ ×§×©×¨</a>.</p>	\N
10745	0		pl	2013-07-15 20:30:16	\N	<h2>Przede wszystkim, simpleness ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS - jest open-source Perl systemu CMS.</strong><br>PodstawowÄ… zasadÄ… systemu - prostsza, tym lepiej. <a href=\\"http://cms.simpleness.org/about\\">Dowiedz siÄ™ wiÄ™cej</a>.</p><br>Najnowsza wersja - 0.36 zostaÅ‚a wydana 15 lipca. MoÅ¼esz pobraÄ‡ ten system od <a href=\\"http://cms.simpleness.org/download\\">Ta strona</a>.\\n<p><br>Czekam na wasze komentarze na temat idei i kodu. JeÅ›li chcesz wziÄ…Ä‡ udziaÅ‚ w rozwoju - proszÄ™ <a href=\\"http://cms.simpleness.org/contacts\\">kontakt</a>.</p>	\N
10746	0		lv	2013-07-15 20:30:16	\N	<h2>PirmkÄrt, Simpleness ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS - ir atvÄ“rtÄ pirmkoda Perl CMS sistÄ“ma.</strong><br>Pamatprincips sistÄ“mas - vienkÄrÅ¡Äk, jo labÄk. <a href=\\"http://cms.simpleness.org/about\\">Uzzini vairÄk</a>.</p><br>PÄ“dÄ“jÄ versija - 0,36 tika izlaists gada 15 jÅ«lijÄ. JÅ«s varat lejupielÄdÄ“t Å¡o sistÄ“mu no <a href=\\"http://cms.simpleness.org/download\\">Å¡o lapu</a>.\\n<p><br>Gaida jÅ«su komentÄrus par ideju un kodu. Ja vÄ“laties piedalÄ«ties attÄ«stÄ«bÄ - lÅ«dzu, <a href=\\"http://cms.simpleness.org/contacts\\">sazinieties ar mani</a>.</p>	\N
10747	0		et	2013-07-15 20:30:16	\N	<h2>Esiteks Simpleness ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS - on avatud lÃ¤htekoodiga Perl CMS sÃ¼steem.</strong><br>PÃµhiprintsiip sÃ¼steem - lihtsam, seda parem. <a href=\\"http://cms.simpleness.org/about\\">Uuri rohkem</a>.</p><br>Viimane versioon - 0.36 ilmus 15. juulil. VÃµite alla laadida selle sÃ¼steemi <a href=\\"http://cms.simpleness.org/download\\">seda lehte</a>.\\n<p><br>Ootan teie kommentaare idee ja kood. Kui soovite osaleda areng - palun <a href=\\"http://cms.simpleness.org/contacts\\">minuga</a>.</p>	\N
10748	0		lt	2013-07-15 20:30:16	\N	<h2>Pirmiausia, Simpleness ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS - tai atviro kodo Perl TVS sistema.</strong><br>Pagrindinis Å¡ios sistemos principÄ… - paprasÄiau, tuo geriau. <a href=\\"http://cms.simpleness.org/about\\">SuÅ¾inokite daugiau</a>.</p><br>Paskutinis versija - 0,36 buvo iÅ¡leistas liepos 15. JÅ«s galite atsisiÅ³sti Å¡iÄ… sistemÄ… iÅ¡ <a href=\\"http://cms.simpleness.org/download\\">Å¡iuo puslapiu</a>.\\n<p><br>Mes laukiame jÅ«sÅ³ komentarÅ³ apie idÄ—jÄ… ir kodÄ…. Jei norite dalyvauti kuriant - praÅ¡ome <a href=\\"http://cms.simpleness.org/contacts\\">susisiekite su manimi</a>.</p>	\N
10749	0		nl	2013-07-15 20:30:16	\N	<h2>Allereerst, Eenvoud ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS - is een open-source Perl CMS-systeem.</strong><br>Uitgangspunt van het systeem - het eenvoudiger, hoe beter. <a href=\\"http://cms.simpleness.org/about\\">Meer informatie</a>.</p><br>Laatste versie - 0.36 werd uitgebracht op 15 juli. U kunt dit systeem downloaden van <a href=\\"http://cms.simpleness.org/download\\">deze pagina</a>.\\n<p><br>Wachten voor uw commentaar over idee en code. Indien u wilt deelnemen aan de ontwikkeling - neem <a href=\\"http://cms.simpleness.org/contacts\\">contact met mij op</a>.</p>	\N
10750	0		bg	2013-07-15 20:30:16	\N	<h2>ÐÐ° Ð¿ÑŠÑ€Ð²Ð¾ Ð¼ÑÑÑ‚Ð¾, Ð¿Ñ€Ð¾ÑÑ‚Ð¾Ñ‚Ð° ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS - Ðµ Ñ Ð¾Ñ‚Ð²Ð¾Ñ€ÐµÐ½ ÐºÐ¾Ð´, Perl CMS ÑÐ¸ÑÑ‚ÐµÐ¼Ð°.</strong><br>ÐžÑÐ½Ð¾Ð²Ð½Ð¸ÑÑ‚ Ð¿Ñ€Ð¸Ð½Ñ†Ð¸Ð¿ Ð½Ð° ÑÐ¸ÑÑ‚ÐµÐ¼Ð°Ñ‚Ð° - Ð¿Ð¾-Ð¾Ð¿Ñ€Ð¾ÑÑ‚ÐµÐ½Ð°, Ð¿Ð¾-Ð´Ð¾Ð±Ñ€Ðµ. <a href=\\"http://cms.simpleness.org/about\\">Ð’Ð¸Ð¶ Ð¿Ð¾Ð²ÐµÑ‡Ðµ</a>.</p><br>ÐŸÐ¾ÑÐ»ÐµÐ´Ð½Ð° Ð²ÐµÑ€ÑÐ¸Ñ - 0.36 Ðµ Ð¿ÑƒÑÐ½Ð°Ñ‚Ð° Ð½Ð° 15 ÑŽÐ»Ð¸. ÐœÐ¾Ð¶ÐµÑ‚Ðµ Ð´Ð° Ð¸Ð·Ñ‚ÐµÐ³Ð»Ð¸Ñ‚Ðµ Ñ‚Ð°Ð·Ð¸ ÑÐ¸ÑÑ‚ÐµÐ¼Ð° Ð¾Ñ‚ <a href=\\"http://cms.simpleness.org/download\\">Ñ‚Ð°Ð·Ð¸ ÑÑ‚Ñ€Ð°Ð½Ð¸Ñ†Ð°</a>.\\n<p><br>Ð§Ð°ÐºÐ°Ñ‰Ð¸ Ð·Ð° Ð²Ð°ÑˆÐ¸Ñ‚Ðµ ÐºÐ¾Ð¼ÐµÐ½Ñ‚Ð°Ñ€Ð¸ Ð·Ð° Ð¸Ð´ÐµÑÑ‚Ð° Ð¸ ÐºÐ¾Ð´. ÐÐºÐ¾ Ð¶ÐµÐ»Ð°ÐµÑ‚Ðµ Ð´Ð° ÑƒÑ‡Ð°ÑÑ‚Ð²Ð°Ñ‚Ðµ Ð² Ñ€Ð°Ð·Ð²Ð¸Ñ‚Ð¸ÐµÑ‚Ð¾ - Ð¼Ð¾Ð»Ñ <a href=\\"http://cms.simpleness.org/contacts\\">ÑÐ²ÑŠÑ€Ð¶ÐµÑ‚Ðµ ÑÐµ Ñ Ð¼ÐµÐ½</a>.</p>	\N
10751	0		ro	2013-07-15 20:30:16	\N	<h2>ÃŽn primul rÃ¢nd, Simplitatea ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS - este un sistem open-source Perl CMS.</strong><br>Principiul de bazÄƒ al sistemului - mai simplu, cu atÃ¢t mai bine. <a href=\\"http://cms.simpleness.org/about\\">Afla&#539;i mai multe</a>.</p><br>Ultima versiune - 0.36 a fost lansat la 15 iulie. Pute&#539;i descÄƒrca acest sistem de <a href=\\"http://cms.simpleness.org/download\\">aceastÄƒ paginÄƒ</a>.\\n<p><br>ÃŽn a&#537;teptare pentru comentariile dvs. despre ideea &#537;i cod. DacÄƒ dori&#539;i sÄƒ participa&#539;i la dezvoltarea - vÄƒ rugÄƒm sÄƒ <a href=\\"http://cms.simpleness.org/contacts\\">contactati-ma</a>.</p>	\N
10752	0		da	2013-07-15 20:30:16	\N	<h2>FÃ¸rst og fremmest, Simpleness ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simpleness CMS - er et open-source Perl CMS system.</strong><br>Det grundlÃ¦ggende princip i system - enklere, jo bedre. <a href=\\"http://cms.simpleness.org/about\\">Find ud af mere</a>.</p><br>Sidste udgave - 0,36 blev udgivet den 15. juli. Du kan downloade dette system fra <a href=\\"http://cms.simpleness.org/download\\">denne side</a>.\\n<p><br>Venter pÃ¥ dine kommentarer om idÃ© og kode. Hvis du Ã¸nsker at deltage i udviklingen - venligst <a href=\\"http://cms.simpleness.org/contacts\\">kontakt mig</a>.</p>	\N
10753	0		ko	2013-07-15 20:30:16	\N	<h2>ì²«ì§¸ë¡œ ëª¨ë‘ì˜, ê°„ê²°í•¨ ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>ê°„ê²°í•¨ CMSëŠ” - ì˜¤í”ˆ ì†ŒìŠ¤ íŽ„ CMS ì‹œìŠ¤í…œìž…ë‹ˆë‹¤.</strong><br>ì‹œìŠ¤í…œì˜ ê¸°ë³¸ ì›ë¦¬ -, ë” ê°„ë‹¨. <a href=\\"http://cms.simpleness.org/about\\">ìžì„¸í•œ ë‚´ìš©ì„ ì•Œì•„ë³´ì‹­ì‹œì˜¤</a>.</p><br>ë§ˆì§€ë§‰ ë²„ì „ - 0.36 7 ì›” 15 ì¼ì— ë¦´ë¦¬ìŠ¤ë˜ì—ˆìŠµë‹ˆë‹¤. ë‹¹ì‹ ì€ì—ì„œì´ ì‹œìŠ¤í…œì„ ë‹¤ìš´ë¡œë“œ í•  ìˆ˜ ìžˆìŠµë‹ˆë‹¤ <a href=\\"http://cms.simpleness.org/download\\">ì´ íŽ˜ì´ì§€ë¥¼</a>.\\n<p><br>ì•„ì´ë””ì–´ì™€ ì½”ë“œì— ëŒ€í•œ ê·€í•˜ì˜ ì˜ê²¬ì„ ê¸°ë‹¤ë¦¬ê³ . ë‹¹ì‹ ì´ ê°œë°œì— ì°¸ì—¬í•˜ê³ ìží•˜ëŠ” ê²½ìš° -í•˜ì‹­ì‹œì˜¤ <a href=\\"http://cms.simpleness.org/contacts\\">ì €ì—ê²Œ ì—°ë½</a>.</p>	\N
10754	0		pt	2013-07-15 20:30:16	\N	<h2>Primeiro de tudo, Simpleness ...</h2>\\n<p>&nbsp;</p>\\n<p><strong>Simplicidade CMS - Ã© um sistema open-source Perl CMS.</strong><br>O princÃ­pio bÃ¡sico do sistema - o mais simples, melhor. <a href=\\"http://cms.simpleness.org/about\\">Saiba mais</a>.</p><br>Ãšltima versÃ£o - 0.36 foi lanÃ§ado em 15 de julho. VocÃª pode baixar este sistema de <a href=\\"http://cms.simpleness.org/download\\">esta pÃ¡gina</a>.\\n<p><br>Ã€ espera de seus comentÃ¡rios sobre idÃ©ia e cÃ³digo. Se vocÃª deseja participar do desenvolvimento - por favor <a href=\\"http://cms.simpleness.org/contacts\\">entrar em contato comigo</a>.</p>	\N
10759	0	_bottom	en	2013-07-15 20:33:06	\N	<span><p>&nbsp;(c) 2010-2013, <a href=\\"/\\">Simpleness CMS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br></a></p></span>\\n	\N
10867	0	/contacts	ru	2014-06-18 11:47:18	\N	<h2>\\n\tÐšÐ¾Ð½Ñ‚Ð°ÐºÑ‚Ñ‹</h2>&nbsp;\\n<h2>\\n\tÐžÐ±Ñ€Ð°Ñ‚Ð½Ð°Ñ ÑÐ²ÑÐ·ÑŒ</h2>{contacts/index}\\n	\N
10869	0	/admin/menu	ru	2014-06-18 11:49:35	\N	<h1><a target=\\"\\" title=\\"\\" href=\\"http://odn.org.ua\\">ÐŸÐ¾Ð¼Ð¾Ñ‰Ð½Ð¸Ðº Ð´Ð»Ñ Ð²ÑÐµÑ…</a><br></h1><p><a target=\\"\\" title=\\"\\" href=\\"http://admin.gioc:8080\\"><font color=\\"#FFFFFF\\">odn.org.ua</font></a><br></p>	\N
10871	0	/news	ru	2014-06-18 11:53:05	\N	<h1>Ð“Ð˜ÐžÐ¦<br></h1><p><font color=\\"#FFFFFF\\">admin.gioc</font><br></p>	\N
10874	0	/login/success	ru	2014-06-18 13:10:03	\N	<h1><a target=\\"\\" title=\\"\\" href=\\"http://odn.org.ua\\">ÐŸÐ¾Ð¼Ð¾Ñ‰Ð½Ð¸Ðº Ð´Ð»Ñ Ð²ÑÐµÑ…</a> <br></h1><p><font color=\\"#FFFFFF\\"><a target=\\"\\" title=\\"\\" href=\\"http://odn.org.ua\\">odn.org.ua</a></font><br></p>	\N
10879	0	_header	ru	2014-06-18 13:13:53	\N	<h1>Ð“Ð˜Ð’Ð¦<br></h1><p><a target=\\"\\" title=\\"\\" href=\\"http://admin.gioc:8080\\"><font color=\\"#FFFFFF\\">admin.gioc</font></a><br></p>	\N
10880	0	_bottom	ru	2014-06-18 13:14:39	\N	<span><p><span>(c) 2014,</span> <span>Ð“Ð˜Ð’Ð¦ -</span> <a target=\\"\\" title=\\"\\" href=\\"http://admin.gioc:8080\\">admin.gioc</a><br></p></span>\\n	\N
10885	0		ru	2014-06-19 10:36:01	\N	<br>ÐŸÐ¾Ð»ÑƒÑ‡Ð¸Ñ‚ÑŒ Ð¸Ð½Ñ„Ð¾Ñ€Ð¼Ð°Ñ†Ð¸ÑŽ Ð¾ Ð±Ð¸Ð»ÐµÑ‚Ðµ Ð¿Ð¾ ÐµÐ³Ð¾ ÐºÐ¾Ð´Ñƒ Ð¼Ð¾Ð¶Ð½Ð¾ Ð² Ñ€Ð°Ð·Ð´ÐµÐ»Ðµ <a target=\\"\\" title=\\"\\" href=\\"/info\\">Ð¸Ð½Ñ„Ð¾Ñ€Ð¼Ð°Ñ†Ð¸Ñ</a><br>	\N
\.


--
-- TOC entry 2098 (class 0 OID 0)
-- Dependencies: 167
-- Name: base_content_content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('base_content_content_id_seq', 1, false);


--
-- TOC entry 2055 (class 0 OID 34881)
-- Dependencies: 170 2074
-- Data for Name: base_gallery; Type: TABLE DATA; Schema: public; Owner: -
--

COPY base_gallery (gal_id, gal_name, gal_description, lang, gal_key) FROM stdin;
1	\\x7364667364	\\x7364667364667364663c62723e	ru	1
\.


--
-- TOC entry 2099 (class 0 OID 0)
-- Dependencies: 169
-- Name: base_gallery_gal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('base_gallery_gal_id_seq', 1, false);


--
-- TOC entry 2057 (class 0 OID 34893)
-- Dependencies: 172 2074
-- Data for Name: base_gallery_images; Type: TABLE DATA; Schema: public; Owner: -
--

COPY base_gallery_images (img_id, img_name, img_order, gal_key) FROM stdin;
\.


--
-- TOC entry 2100 (class 0 OID 0)
-- Dependencies: 171
-- Name: base_gallery_images_img_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('base_gallery_images_img_id_seq', 1, false);


--
-- TOC entry 2061 (class 0 OID 34913)
-- Dependencies: 176 2074
-- Data for Name: base_menu; Type: TABLE DATA; Schema: public; Owner: -
--

COPY base_menu (menu_id, menu_name, lang, menu_key) FROM stdin;
21	\\x4e657773	en	22
32	\\xd09dd0b020d0b3d0bbd0b0d0b2d0bdd183d18e	ru	19
35	\\xd09dd0bed0b2d0bed181d182d0b8	ru	22
44	\\xd09dd0bed0b2d0b8d0bdd0b8	ua	22
53	\\x4e6f7576656c6c6573	fr	22
62	\\x4e6163687269636874656e	de	22
71	\\x4e6f746963696173	es	22
80	\\x4e6f74697a6965	it	22
89	\\xce95ceb9ceb4ceaecf83ceb5ceb9cf82	gr	22
98	\\xe696b0e997bb	ch	22
107	\\xe3838be383a5e383bce382b9	jp	22
116	\\x4861626572	tr	22
125	\\xd8a3d8aed8a8d8a7d8b1	ar	22
134	\\xd8a7d8aed8a8d8a7d8b1	fa	22
143	\\xd797d793d7a9d795d7aa	il	22
152	\\x416b7475616c6e6fc59b6369	pl	22
161	\\x4a61756e756d69	lv	22
170	\\x55756469736564	et	22
179	\\x4e61756a69656e6f73	lt	22
188	\\x4e6965757773	nl	22
197	\\xd09dd0bed0b2d0b8d0bdd0b8	bg	22
206	\\x26233533363b74697269	ro	22
215	\\x4e796865646572	da	22
224	\\xeb89b4ec8aa4	ko	22
233	\\x4e6f74c3ad636961	pt	22
446	\\xd098d0bdd184d0bed180d0bcd0b0d186d0b8d18f	ru	25
447	\\xd09fd0bed0b8d181d0ba20d0bfd0bed0b5d0b7d0b4d0bed0b2	ru	26
\.


--
-- TOC entry 2101 (class 0 OID 0)
-- Dependencies: 175
-- Name: base_menu_menu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('base_menu_menu_id_seq', 1, false);


--
-- TOC entry 2059 (class 0 OID 34902)
-- Dependencies: 174 2074
-- Data for Name: base_menu_url; Type: TABLE DATA; Schema: public; Owner: -
--

COPY base_menu_url (menu_key, menu_url, menu_parent, menu_order) FROM stdin;
19	\\x2f	0	1
22	\\x2f6e657773	0	3
25	\\x2f696e666f	0	4
26	\\x2f747261696e73	0	5
\.


--
-- TOC entry 2102 (class 0 OID 0)
-- Dependencies: 173
-- Name: base_menu_url_menu_key_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('base_menu_url_menu_key_seq', 1, false);


--
-- TOC entry 2063 (class 0 OID 34930)
-- Dependencies: 178 2074
-- Data for Name: base_news; Type: TABLE DATA; Schema: public; Owner: -
--

COPY base_news (news_id, news_date, lang, news_name, news_body, news_key) FROM stdin;
1176	2014-06-19 10:28:14	ru	\\xd09fd180d0bed181d0bcd0bed182d18020d0b8d0bdd184d0bed180d0bcd0b0d186d0b8d0b820d0be20d0b1d0b8d0bbd0b5d182d0b5	\\x0a09202020200a0920202020d094d0bed0b1d0b0d0b2d0bbd0b5d0bdd0b020d0b2d0bed0b7d0bcd0bed0b6d0bdd0bed181d182d18c20d0bfd180d0bed181d0bcd0bed182d180d0b020d0b8d0bdd184d0bed180d0bcd0b0d186d0b8d0b820d0be20d0b1d0b8d0bbd0b5d182d0b520d0bfd0be20d0bdd0bed0bcd0b5d180d18320d0b7d0b0d0bad0b0d0b7d0b02e3c62723e3c62723ed0add182d18320d0b8d0bdd184d0bed180d0bcd0b0d186d0b8d18e20d0bcd0bed0b6d0bdd0be20d0bdd0b0d0b9d182d0b820d0bdd0b020d181d182d180d0b0d0bdd0b8d186d0b520223c61207461726765743d2222207469746c653d222220687265663d222f696e666f223ed098d0bdd184d0bed180d0bcd0b0d186d0b8d18f3c2f613e222e3c62723e3c62723ed09dd0bed0bcd0b5d18020d0b1d0b8d0bbd0b5d182d0b020d0bdd0b0d185d0bed0b4d0b8d182d181d18f20d0b0d0b2d182d0bed0bcd0b0d182d0b8d187d0b5d181d0bad0b82e3c62723e3c62723ed092d181d18f20d0b8d0bdd184d0bed180d0bcd0b0d186d0b8d18f20d0bfd180d0b8d185d0bed0b4d0b8d18220d0bed18220d180d0b0d0b1d0bed187d0b5d0b3d0be20d181d0b5d180d0b2d0b5d180d0b020d093d098d092d0a62c20d0bfd0bed18dd182d0bed0bcd1832c20d0bfd0bed181d18cd0b1d0b02c20d181d0b8d0bbd18cd0bdd0be20d0bdd0b520d0bfd0b5d180d0b5d0b7d0b0d0b3d180d183d0b6d0b0d182d18c2e3c62723e3c62723e0909	1
\.


--
-- TOC entry 2103 (class 0 OID 0)
-- Dependencies: 177
-- Name: base_news_news_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('base_news_news_id_seq', 1, false);


--
-- TOC entry 2049 (class 0 OID 34832)
-- Dependencies: 164 2074
-- Data for Name: base_users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY base_users (user_id, user_login, user_password, user_email, user_name, user_lang, group_id) FROM stdin;
1	admin	b93dcbd2a6f3f4a1cecef509b8762615	no@email	Admin		2
\.


--
-- TOC entry 2065 (class 0 OID 34944)
-- Dependencies: 180 2074
-- Data for Name: base_users_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY base_users_config (config_id, user_id, config_name, config_value) FROM stdin;
181	1	comments_show	0
\.


--
-- TOC entry 2104 (class 0 OID 0)
-- Dependencies: 179
-- Name: base_users_config_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('base_users_config_config_id_seq', 1, false);


--
-- TOC entry 2067 (class 0 OID 34955)
-- Dependencies: 182 2074
-- Data for Name: base_users_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY base_users_groups (group_id, group_name) FROM stdin;
1	
2	root
3	admin
5	registered
\.


--
-- TOC entry 2069 (class 0 OID 34963)
-- Dependencies: 184 2074
-- Data for Name: base_users_groups_access; Type: TABLE DATA; Schema: public; Owner: -
--

COPY base_users_groups_access (access_id, group_id, access_name) FROM stdin;
2914	1	print_page
2915	1	view_addthis
2916	2	add_news
2917	2	add_subscribe
2918	2	edit_content
2919	2	edit_menu
2920	2	edit_user_access
2921	2	email_page
2922	2	import_base
2923	2	manage_gallery
2924	2	settings
2925	2	site_update
2926	3	print_page
2927	3	view_addthis
2928	5	print_page
2929	5	view_addthis
\.


--
-- TOC entry 2105 (class 0 OID 0)
-- Dependencies: 183
-- Name: base_users_groups_access_access_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('base_users_groups_access_access_id_seq', 1, false);


--
-- TOC entry 2106 (class 0 OID 0)
-- Dependencies: 181
-- Name: base_users_groups_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('base_users_groups_group_id_seq', 1, false);


--
-- TOC entry 2071 (class 0 OID 34976)
-- Dependencies: 186 2074
-- Data for Name: base_users_recover; Type: TABLE DATA; Schema: public; Owner: -
--

COPY base_users_recover (user_id, recover, date) FROM stdin;
\.


--
-- TOC entry 2107 (class 0 OID 0)
-- Dependencies: 185
-- Name: base_users_recover_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('base_users_recover_user_id_seq', 1, false);


--
-- TOC entry 2073 (class 0 OID 34987)
-- Dependencies: 188 2074
-- Data for Name: base_users_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY base_users_settings (setting_id, user_id, setting_name, setting_value) FROM stdin;
\.


--
-- TOC entry 2108 (class 0 OID 0)
-- Dependencies: 187
-- Name: base_users_settings_setting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('base_users_settings_setting_id_seq', 1, false);


--
-- TOC entry 2109 (class 0 OID 0)
-- Dependencies: 163
-- Name: base_users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('base_users_user_id_seq', 1, false);


--
-- TOC entry 1911 (class 2606 OID 34829)
-- Dependencies: 162 162 2075
-- Name: base_calls_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_calls
    ADD CONSTRAINT base_calls_pkey PRIMARY KEY (calls_id);


--
-- TOC entry 1915 (class 2606 OID 34858)
-- Dependencies: 166 166 2075
-- Name: base_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_comments
    ADD CONSTRAINT base_comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 1917 (class 2606 OID 34876)
-- Dependencies: 168 168 2075
-- Name: base_content_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_content
    ADD CONSTRAINT base_content_pkey PRIMARY KEY (content_id);


--
-- TOC entry 1921 (class 2606 OID 34899)
-- Dependencies: 172 172 2075
-- Name: base_gallery_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_gallery_images
    ADD CONSTRAINT base_gallery_images_pkey PRIMARY KEY (img_id);


--
-- TOC entry 1919 (class 2606 OID 34890)
-- Dependencies: 170 170 2075
-- Name: base_gallery_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_gallery
    ADD CONSTRAINT base_gallery_pkey PRIMARY KEY (gal_id);


--
-- TOC entry 1925 (class 2606 OID 34922)
-- Dependencies: 176 176 2075
-- Name: base_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_menu
    ADD CONSTRAINT base_menu_pkey PRIMARY KEY (menu_id);


--
-- TOC entry 1923 (class 2606 OID 34910)
-- Dependencies: 174 174 2075
-- Name: base_menu_url_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_menu_url
    ADD CONSTRAINT base_menu_url_pkey PRIMARY KEY (menu_key);


--
-- TOC entry 1927 (class 2606 OID 34939)
-- Dependencies: 178 178 2075
-- Name: base_news_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_news
    ADD CONSTRAINT base_news_pkey PRIMARY KEY (news_id);


--
-- TOC entry 1929 (class 2606 OID 34952)
-- Dependencies: 180 180 2075
-- Name: base_users_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_users_config
    ADD CONSTRAINT base_users_config_pkey PRIMARY KEY (config_id);


--
-- TOC entry 1933 (class 2606 OID 34968)
-- Dependencies: 184 184 2075
-- Name: base_users_groups_access_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_users_groups_access
    ADD CONSTRAINT base_users_groups_access_pkey PRIMARY KEY (access_id);


--
-- TOC entry 1931 (class 2606 OID 34960)
-- Dependencies: 182 182 2075
-- Name: base_users_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_users_groups
    ADD CONSTRAINT base_users_groups_pkey PRIMARY KEY (group_id);


--
-- TOC entry 1913 (class 2606 OID 34843)
-- Dependencies: 164 164 2075
-- Name: base_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_users
    ADD CONSTRAINT base_users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 1935 (class 2606 OID 34982)
-- Dependencies: 186 186 2075
-- Name: base_users_recover_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_users_recover
    ADD CONSTRAINT base_users_recover_pkey PRIMARY KEY (user_id);


--
-- TOC entry 1937 (class 2606 OID 34995)
-- Dependencies: 188 188 2075
-- Name: base_users_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_users_settings
    ADD CONSTRAINT base_users_settings_pkey PRIMARY KEY (setting_id);


--
-- TOC entry 1942 (class 2620 OID 34878)
-- Dependencies: 168 201 2075
-- Name: update_base_content_content_date_from; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_base_content_content_date_from BEFORE UPDATE ON base_content FOR EACH ROW EXECUTE PROCEDURE update_content_date_from_column();


--
-- TOC entry 1943 (class 2620 OID 34941)
-- Dependencies: 202 178 2075
-- Name: update_base_news_news_date; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_base_news_news_date BEFORE UPDATE ON base_news FOR EACH ROW EXECUTE PROCEDURE update_news_date_column();


--
-- TOC entry 1944 (class 2620 OID 34984)
-- Dependencies: 203 186 2075
-- Name: update_base_users_recover_date; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_base_users_recover_date BEFORE UPDATE ON base_users_recover FOR EACH ROW EXECUTE PROCEDURE update_date_column();


--
-- TOC entry 1938 (class 2606 OID 34859)
-- Dependencies: 164 166 1912 2075
-- Name: fk_base_comments_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_comments
    ADD CONSTRAINT fk_base_comments_user_id FOREIGN KEY (user_id) REFERENCES base_users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1939 (class 2606 OID 34923)
-- Dependencies: 176 174 1922 2075
-- Name: fk_base_menu_1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_menu
    ADD CONSTRAINT fk_base_menu_1 FOREIGN KEY (menu_key) REFERENCES base_menu_url(menu_key) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1940 (class 2606 OID 34969)
-- Dependencies: 1930 184 182 2075
-- Name: fk_base_users_groups_access_1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_users_groups_access
    ADD CONSTRAINT fk_base_users_groups_access_1 FOREIGN KEY (group_id) REFERENCES base_users_groups(group_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1941 (class 2606 OID 34996)
-- Dependencies: 164 1912 188 2075
-- Name: fk_base_users_settings_1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_users_settings
    ADD CONSTRAINT fk_base_users_settings_1 FOREIGN KEY (user_id) REFERENCES base_users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2080 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2014-10-14 10:03:00 EEST

--
-- PostgreSQL database dump complete
--

