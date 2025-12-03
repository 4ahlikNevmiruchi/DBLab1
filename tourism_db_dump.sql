--
-- PostgreSQL database dump
--

\restrict FpfqtIwXI8KHZZoadrRih3T9FYfDqtY7NKQgVye7jSFwzMwP0TtetTEc7GMHnfn

-- Dumped from database version 17.6 (Ubuntu 17.6-1build1)
-- Dumped by pg_dump version 17.6 (Ubuntu 17.6-1build1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: fn_update_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_update_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_update_timestamp() OWNER TO postgres;

--
-- Name: sp_create_tour(character varying, text, integer, numeric, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_create_tour(IN p_name character varying, IN p_desc text, IN p_days integer, IN p_price numeric, IN p_creator_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO tours (name, description, duration_days, base_price, updated_by)
    VALUES (p_name, p_desc, p_days, p_price, p_creator_id);
END;
$$;


ALTER PROCEDURE public.sp_create_tour(IN p_name character varying, IN p_desc text, IN p_days integer, IN p_price numeric, IN p_creator_id integer) OWNER TO postgres;

--
-- Name: sp_soft_delete_booking(bigint, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_soft_delete_booking(IN p_booking_id bigint, IN p_user_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE bookings
    SET is_deleted = TRUE,
        updated_by = p_user_id,
        updated_at = NOW()
    WHERE id = p_booking_id;
    
    -- Можна додати логування в окрему таблицю логів тут
END;
$$;


ALTER PROCEDURE public.sp_soft_delete_booking(IN p_booking_id bigint, IN p_user_id integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: booking_statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking_statuses (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.booking_statuses OWNER TO postgres;

--
-- Name: booking_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.booking_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.booking_statuses_id_seq OWNER TO postgres;

--
-- Name: booking_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.booking_statuses_id_seq OWNED BY public.booking_statuses.id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    id bigint NOT NULL,
    user_id integer,
    status_id integer,
    tour_date_id bigint,
    hotel_id bigint,
    total_price numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone,
    updated_by integer,
    is_deleted boolean DEFAULT false
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bookings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bookings_id_seq OWNER TO postgres;

--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    id integer NOT NULL,
    country_id integer,
    name character varying(100) NOT NULL
);


ALTER TABLE public.cities OWNER TO postgres;

--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cities_id_seq OWNER TO postgres;

--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cities_id_seq OWNED BY public.cities.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    iso_code character(3)
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.countries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.countries_id_seq OWNER TO postgres;

--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: hotel_chains; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotel_chains (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    website character varying(255)
);


ALTER TABLE public.hotel_chains OWNER TO postgres;

--
-- Name: hotel_chains_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hotel_chains_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hotel_chains_id_seq OWNER TO postgres;

--
-- Name: hotel_chains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hotel_chains_id_seq OWNED BY public.hotel_chains.id;


--
-- Name: hotels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotels (
    id bigint NOT NULL,
    chain_id integer,
    location_id bigint,
    name character varying(150) NOT NULL,
    stars integer,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone,
    updated_by integer,
    is_deleted boolean DEFAULT false,
    CONSTRAINT hotels_stars_check CHECK (((stars >= 1) AND (stars <= 5)))
);


ALTER TABLE public.hotels OWNER TO postgres;

--
-- Name: hotels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hotels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hotels_id_seq OWNER TO postgres;

--
-- Name: hotels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hotels_id_seq OWNED BY public.hotels.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locations (
    id bigint NOT NULL,
    city_id integer,
    address_line character varying(255),
    latitude numeric(9,6),
    longitude numeric(9,6)
);


ALTER TABLE public.locations OWNER TO postgres;

--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locations_id_seq OWNER TO postgres;

--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id bigint NOT NULL,
    booking_id bigint,
    amount numeric(10,2) NOT NULL,
    payment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    payment_method character varying(50)
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_id_seq OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    id bigint NOT NULL,
    user_id integer,
    tour_id bigint,
    hotel_id bigint,
    rating integer,
    comment text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT reviews_rating_check CHECK (((rating >= 1) AND (rating <= 10)))
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_id_seq OWNER TO postgres;

--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: room_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.room_types (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    base_price numeric(10,2) NOT NULL
);


ALTER TABLE public.room_types OWNER TO postgres;

--
-- Name: room_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.room_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.room_types_id_seq OWNER TO postgres;

--
-- Name: room_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.room_types_id_seq OWNED BY public.room_types.id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rooms (
    id bigint NOT NULL,
    hotel_id bigint,
    room_type_id integer,
    room_number character varying(20) NOT NULL,
    floor integer,
    is_available boolean DEFAULT true
);


ALTER TABLE public.rooms OWNER TO postgres;

--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rooms_id_seq OWNER TO postgres;

--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- Name: tour_dates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tour_dates (
    id bigint NOT NULL,
    tour_id bigint,
    start_date date NOT NULL,
    end_date date NOT NULL,
    max_capacity integer
);


ALTER TABLE public.tour_dates OWNER TO postgres;

--
-- Name: tour_dates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tour_dates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tour_dates_id_seq OWNER TO postgres;

--
-- Name: tour_dates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tour_dates_id_seq OWNED BY public.tour_dates.id;


--
-- Name: tour_guide_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tour_guide_assignments (
    tour_date_id bigint NOT NULL,
    guide_id integer NOT NULL,
    assigned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tour_guide_assignments OWNER TO postgres;

--
-- Name: tour_guides; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tour_guides (
    id integer NOT NULL,
    user_id integer,
    license_number character varying(50),
    years_experience integer
);


ALTER TABLE public.tour_guides OWNER TO postgres;

--
-- Name: tour_guides_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tour_guides_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tour_guides_id_seq OWNER TO postgres;

--
-- Name: tour_guides_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tour_guides_id_seq OWNED BY public.tour_guides.id;


--
-- Name: tours; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tours (
    id bigint NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    duration_days integer,
    base_price numeric(10,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone,
    updated_by integer,
    is_deleted boolean DEFAULT false
);


ALTER TABLE public.tours OWNER TO postgres;

--
-- Name: tours_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tours_id_seq OWNER TO postgres;

--
-- Name: tours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tours_id_seq OWNED BY public.tours.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    role_id integer,
    email character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    first_name character varying(100),
    last_name character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_active boolean DEFAULT true
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: v_active_hotels_details; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_active_hotels_details AS
 SELECT h.id,
    h.name AS hotel_name,
    h.stars,
    c.name AS city_name,
    co.name AS country_name,
    h.updated_at
   FROM (((public.hotels h
     JOIN public.locations l ON ((h.location_id = l.id)))
     JOIN public.cities c ON ((l.city_id = c.id)))
     JOIN public.countries co ON ((c.country_id = co.id)))
  WHERE (h.is_deleted = false);


ALTER VIEW public.v_active_hotels_details OWNER TO postgres;

--
-- Name: v_user_booking_stats; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_user_booking_stats AS
 SELECT u.id AS user_id,
    u.email,
    count(b.id) AS total_bookings,
    sum(b.total_price) AS total_spent
   FROM (public.users u
     LEFT JOIN public.bookings b ON ((u.id = b.user_id)))
  WHERE (b.is_deleted = false)
  GROUP BY u.id, u.email;


ALTER VIEW public.v_user_booking_stats OWNER TO postgres;

--
-- Name: booking_statuses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_statuses ALTER COLUMN id SET DEFAULT nextval('public.booking_statuses_id_seq'::regclass);


--
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- Name: cities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities ALTER COLUMN id SET DEFAULT nextval('public.cities_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: hotel_chains id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_chains ALTER COLUMN id SET DEFAULT nextval('public.hotel_chains_id_seq'::regclass);


--
-- Name: hotels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels ALTER COLUMN id SET DEFAULT nextval('public.hotels_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: room_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room_types ALTER COLUMN id SET DEFAULT nextval('public.room_types_id_seq'::regclass);


--
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- Name: tour_dates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tour_dates ALTER COLUMN id SET DEFAULT nextval('public.tour_dates_id_seq'::regclass);


--
-- Name: tour_guides id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tour_guides ALTER COLUMN id SET DEFAULT nextval('public.tour_guides_id_seq'::regclass);


--
-- Name: tours id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tours ALTER COLUMN id SET DEFAULT nextval('public.tours_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: booking_statuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.booking_statuses (id, name) FROM stdin;
1	Pending
2	Confirmed
3	Paid
4	Cancelled
5	Completed
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (id, user_id, status_id, tour_date_id, hotel_id, total_price, created_at, updated_at, updated_by, is_deleted) FROM stdin;
2	6	2	\N	2	14000.00	2025-12-03 11:28:23.390265	\N	2	f
3	5	4	3	\N	8000.00	2025-12-03 11:28:23.390265	\N	5	f
1	5	3	1	\N	2500.00	2025-12-03 11:28:23.390265	2025-12-03 11:47:42.462829	1	t
\.


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cities (id, country_id, name) FROM stdin;
1	1	Київ
2	1	Львів
3	1	Одеса
4	1	Яремче
5	2	Анталія
6	2	Стамбул
7	3	Шарм-ель-Шейх
8	4	Рим
9	4	Венеція
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (id, name, iso_code) FROM stdin;
1	Україна	UKR
2	Туреччина	TUR
3	Єгипет	EGY
4	Італія	ITA
\.


--
-- Data for Name: hotel_chains; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hotel_chains (id, name, website) FROM stdin;
1	Rixos	https://rixos.com
2	Reikartz	https://reikartz.com
3	Local Gems	\N
\.


--
-- Data for Name: hotels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hotels (id, chain_id, location_id, name, stars, description, created_at, updated_at, updated_by, is_deleted) FROM stdin;
1	2	1	Reikartz Karpaty	4	Затишний готель у серці гір з басейном та спа.	2025-12-03 11:28:23.375557	\N	2	f
2	1	2	Rixos Premium Antalya	5	Розкішний курорт на березі моря "все включено".	2025-12-03 11:28:23.375557	\N	2	f
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locations (id, city_id, address_line, latitude, longitude) FROM stdin;
1	4	вул. Свободи, 20, Яремче	48.450000	24.550000
2	5	Lara Beach, Antalya	36.850000	30.800000
3	1	Андріївський узвіз, Київ	50.460000	30.510000
4	2	Площа Ринок, Львів	49.840000	24.030000
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, booking_id, amount, payment_date, payment_method) FROM stdin;
1	1	2500.00	2025-12-03 11:28:23.392354	Card
2	2	5000.00	2025-12-03 11:28:23.392354	PayPal
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews (id, user_id, tour_id, hotel_id, rating, comment, created_at) FROM stdin;
1	5	1	\N	10	Львів неймовірний, гід Микола - топ!	2025-12-03 11:28:23.39399
2	6	\N	2	9	Готель супер, але море було прохолодне.	2025-12-03 11:28:23.39399
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, description) FROM stdin;
1	Admin	Адміністратор системи з повним доступом
2	Manager	Менеджер контенту (готелі, тури)
3	Guide	Екскурсовод або гід
4	Tourist	Звичайний користувач
\.


--
-- Data for Name: room_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.room_types (id, name, base_price) FROM stdin;
1	Standard	1500.00
2	Deluxe Sea View	3500.00
3	Suite	5000.00
4	Economy	800.00
\.


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rooms (id, hotel_id, room_type_id, room_number, floor, is_available) FROM stdin;
1	1	1	101	1	t
2	1	3	205	2	t
3	2	2	501	5	t
4	2	2	502	5	f
\.


--
-- Data for Name: tour_dates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tour_dates (id, tour_id, start_date, end_date, max_capacity) FROM stdin;
1	1	2023-12-01	2023-12-03	15
2	1	2023-12-15	2023-12-17	15
3	3	2024-01-05	2024-01-10	8
\.


--
-- Data for Name: tour_guide_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tour_guide_assignments (tour_date_id, guide_id, assigned_at) FROM stdin;
1	1	2025-12-03 11:28:23.385949
3	2	2025-12-03 11:28:23.385949
\.


--
-- Data for Name: tour_guides; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tour_guides (id, user_id, license_number, years_experience) FROM stdin;
1	3	LIC-2023-001	5
2	4	LIC-2023-099	3
\.


--
-- Data for Name: tours; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tours (id, name, description, duration_days, base_price, created_at, updated_at, updated_by, is_deleted) FROM stdin;
1	Вікенд у Львові	Гастрономічний тур кав'ярнями та дахами Львова.	2	2500.00	2025-12-03 11:28:23.381417	\N	2	f
2	Містичний Київ	Екскурсія підземеллями та Лисою горою.	1	800.00	2025-12-03 11:28:23.381417	\N	2	f
3	Карпатський драйв	Джип-тур горами, рафтинг та чани.	5	8000.00	2025-12-03 11:28:23.381417	\N	2	f
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, role_id, email, password_hash, first_name, last_name, created_at, is_active) FROM stdin;
1	1	admin@travel.com	hash_admin_123	Олександр	Адміненко	2025-12-03 11:28:23.365335	t
2	2	manager@travel.com	hash_manager_123	Ірина	Менеджерко	2025-12-03 11:28:23.365335	t
3	3	guide1@travel.com	hash_guide_1	Микола	Стежний	2025-12-03 11:28:23.365335	t
4	3	guide2@travel.com	hash_guide_2	Оксана	Гірська	2025-12-03 11:28:23.365335	t
5	4	tourist1@gmail.com	hash_tourist_1	Андрій	Мандрівник	2025-12-03 11:28:23.365335	t
6	4	tourist2@gmail.com	hash_tourist_2	Олена	Подорожня	2025-12-03 11:28:23.365335	t
\.


--
-- Name: booking_statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.booking_statuses_id_seq', 5, true);


--
-- Name: bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bookings_id_seq', 3, true);


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cities_id_seq', 9, true);


--
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.countries_id_seq', 4, true);


--
-- Name: hotel_chains_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hotel_chains_id_seq', 3, true);


--
-- Name: hotels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hotels_id_seq', 2, true);


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.locations_id_seq', 4, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_id_seq', 2, true);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_id_seq', 2, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 4, true);


--
-- Name: room_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.room_types_id_seq', 4, true);


--
-- Name: rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rooms_id_seq', 4, true);


--
-- Name: tour_dates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tour_dates_id_seq', 3, true);


--
-- Name: tour_guides_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tour_guides_id_seq', 2, true);


--
-- Name: tours_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tours_id_seq', 3, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- Name: booking_statuses booking_statuses_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_statuses
    ADD CONSTRAINT booking_statuses_name_key UNIQUE (name);


--
-- Name: booking_statuses booking_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_statuses
    ADD CONSTRAINT booking_statuses_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: countries countries_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_name_key UNIQUE (name);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: hotel_chains hotel_chains_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_chains
    ADD CONSTRAINT hotel_chains_pkey PRIMARY KEY (id);


--
-- Name: hotels hotels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: room_types room_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room_types
    ADD CONSTRAINT room_types_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: tour_dates tour_dates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tour_dates
    ADD CONSTRAINT tour_dates_pkey PRIMARY KEY (id);


--
-- Name: tour_guide_assignments tour_guide_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tour_guide_assignments
    ADD CONSTRAINT tour_guide_assignments_pkey PRIMARY KEY (tour_date_id, guide_id);


--
-- Name: tour_guides tour_guides_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tour_guides
    ADD CONSTRAINT tour_guides_pkey PRIMARY KEY (id);


--
-- Name: tours tours_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tours
    ADD CONSTRAINT tours_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_active_tours; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_active_tours ON public.tours USING btree (base_price) WHERE (is_deleted = false);


--
-- Name: idx_bookings_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_user_id ON public.bookings USING btree (user_id);


--
-- Name: idx_hotels_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hotels_location_id ON public.hotels USING btree (location_id);


--
-- Name: idx_users_email_hash; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email_hash ON public.users USING hash (email);


--
-- Name: bookings trg_bookings_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_bookings_updated BEFORE UPDATE ON public.bookings FOR EACH ROW EXECUTE FUNCTION public.fn_update_timestamp();


--
-- Name: hotels trg_hotels_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_hotels_updated BEFORE UPDATE ON public.hotels FOR EACH ROW EXECUTE FUNCTION public.fn_update_timestamp();


--
-- Name: tours trg_tours_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tours_updated BEFORE UPDATE ON public.tours FOR EACH ROW EXECUTE FUNCTION public.fn_update_timestamp();


--
-- Name: bookings bookings_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(id);


--
-- Name: bookings bookings_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.booking_statuses(id);


--
-- Name: bookings bookings_tour_date_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_tour_date_id_fkey FOREIGN KEY (tour_date_id) REFERENCES public.tour_dates(id);


--
-- Name: bookings bookings_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: bookings bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: cities cities_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id) ON DELETE CASCADE;


--
-- Name: hotels hotels_chain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_chain_id_fkey FOREIGN KEY (chain_id) REFERENCES public.hotel_chains(id);


--
-- Name: hotels hotels_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: hotels hotels_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: locations locations_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: payments payments_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: reviews reviews_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(id);


--
-- Name: reviews reviews_tour_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_tour_id_fkey FOREIGN KEY (tour_id) REFERENCES public.tours(id);


--
-- Name: reviews reviews_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: rooms rooms_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(id);


--
-- Name: rooms rooms_room_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_room_type_id_fkey FOREIGN KEY (room_type_id) REFERENCES public.room_types(id);


--
-- Name: tour_dates tour_dates_tour_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tour_dates
    ADD CONSTRAINT tour_dates_tour_id_fkey FOREIGN KEY (tour_id) REFERENCES public.tours(id);


--
-- Name: tour_guide_assignments tour_guide_assignments_guide_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tour_guide_assignments
    ADD CONSTRAINT tour_guide_assignments_guide_id_fkey FOREIGN KEY (guide_id) REFERENCES public.tour_guides(id);


--
-- Name: tour_guide_assignments tour_guide_assignments_tour_date_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tour_guide_assignments
    ADD CONSTRAINT tour_guide_assignments_tour_date_id_fkey FOREIGN KEY (tour_date_id) REFERENCES public.tour_dates(id);


--
-- Name: tour_guides tour_guides_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tour_guides
    ADD CONSTRAINT tour_guides_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: tours tours_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tours
    ADD CONSTRAINT tours_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict FpfqtIwXI8KHZZoadrRih3T9FYfDqtY7NKQgVye7jSFwzMwP0TtetTEc7GMHnfn

