--
-- PostgreSQL database dump
--

-- Dumped from database version 13.21
-- Dumped by pg_dump version 13.21

-- Started on 2026-06-15 12:00:44

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 203 (class 1259 OID 16814)
-- Name: book; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    description text NOT NULL,
    year integer NOT NULL,
    publisher character varying(200) NOT NULL,
    author character varying(200) NOT NULL,
    pages integer NOT NULL
);


ALTER TABLE public.book OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 16846)
-- Name: book_genre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book_genre (
    book_id integer NOT NULL,
    genre_id integer NOT NULL
);


ALTER TABLE public.book_genre OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 16812)
-- Name: book_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.book_id_seq OWNER TO postgres;

--
-- TOC entry 3082 (class 0 OID 0)
-- Dependencies: 202
-- Name: book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.book_id_seq OWNED BY public.book.id;


--
-- TOC entry 210 (class 1259 OID 16863)
-- Name: cover; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cover (
    id integer NOT NULL,
    filename character varying(200) NOT NULL,
    mime_type character varying(100) NOT NULL,
    md5_hash character varying(32) NOT NULL,
    book_id integer NOT NULL
);


ALTER TABLE public.cover OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16861)
-- Name: cover_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cover_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cover_id_seq OWNER TO postgres;

--
-- TOC entry 3083 (class 0 OID 0)
-- Dependencies: 209
-- Name: cover_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cover_id_seq OWNED BY public.cover.id;


--
-- TOC entry 201 (class 1259 OID 16804)
-- Name: genre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genre (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.genre OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 16802)
-- Name: genre_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.genre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.genre_id_seq OWNER TO postgres;

--
-- TOC entry 3084 (class 0 OID 0)
-- Dependencies: 200
-- Name: genre_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.genre_id_seq OWNED BY public.genre.id;


--
-- TOC entry 214 (class 1259 OID 16894)
-- Name: review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review (
    id integer NOT NULL,
    book_id integer NOT NULL,
    user_id integer NOT NULL,
    rating integer NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    status_id integer NOT NULL
);


ALTER TABLE public.review OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16892)
-- Name: review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.review_id_seq OWNER TO postgres;

--
-- TOC entry 3085 (class 0 OID 0)
-- Dependencies: 213
-- Name: review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.review_id_seq OWNED BY public.review.id;


--
-- TOC entry 207 (class 1259 OID 16838)
-- Name: review_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_status (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.review_status OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 16836)
-- Name: review_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.review_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.review_status_id_seq OWNER TO postgres;

--
-- TOC entry 3086 (class 0 OID 0)
-- Dependencies: 206
-- Name: review_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.review_status_id_seq OWNED BY public.review_status.id;


--
-- TOC entry 205 (class 1259 OID 16825)
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.role OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 16823)
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_id_seq OWNER TO postgres;

--
-- TOC entry 3087 (class 0 OID 0)
-- Dependencies: 204
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;


--
-- TOC entry 212 (class 1259 OID 16876)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    login character varying(100) NOT NULL,
    password_hash character varying(200) NOT NULL,
    last_name character varying(100) NOT NULL,
    first_name character varying(100) NOT NULL,
    middle_name character varying(100),
    role_id integer NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16874)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- TOC entry 3088 (class 0 OID 0)
-- Dependencies: 211
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- TOC entry 2895 (class 2604 OID 16817)
-- Name: book id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book ALTER COLUMN id SET DEFAULT nextval('public.book_id_seq'::regclass);


--
-- TOC entry 2898 (class 2604 OID 16866)
-- Name: cover id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cover ALTER COLUMN id SET DEFAULT nextval('public.cover_id_seq'::regclass);


--
-- TOC entry 2894 (class 2604 OID 16807)
-- Name: genre id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre ALTER COLUMN id SET DEFAULT nextval('public.genre_id_seq'::regclass);


--
-- TOC entry 2900 (class 2604 OID 16897)
-- Name: review id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review ALTER COLUMN id SET DEFAULT nextval('public.review_id_seq'::regclass);


--
-- TOC entry 2897 (class 2604 OID 16841)
-- Name: review_status id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_status ALTER COLUMN id SET DEFAULT nextval('public.review_status_id_seq'::regclass);


--
-- TOC entry 2896 (class 2604 OID 16828)
-- Name: role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);


--
-- TOC entry 2899 (class 2604 OID 16879)
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- TOC entry 3065 (class 0 OID 16814)
-- Dependencies: 203
-- Data for Name: book; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.book (id, title, description, year, publisher, author, pages) FROM stdin;
13	Всё как у людей	Эта антология — итог двадцатилетнего пути автора, который изначально писал фантастику «против себя», а в итоге создал узнаваемый стиль, сочетающий остроумные твисты, ироничные отсылки и серьезные темы. Особая ценность издания — авторские комментарии к каждому тексту. Идиатуллин честно рассказывает, как рождались его рассказы: от случайной надписи на этикетке до спора или сетевого развлечения. «Всё как у людей» — попытка взглянуть на мир глазами того, кто научился видеть за обыденным необычное, за искусственным — настоящее, а за ужасом — надежду.	2022	Альпина.Проза	Шамиль Идиатуллин	354
2	Терра и турнир Тринадцати	**О чем**\nТерра приходит в себя на Острове Небес. Высоко над облаками, где не верят в силу Созвездий, а верят лишь в легенду об Авроре Бореалис, создательнице Зодиака.\n\nКогда память возвращается, Терра вспоминает: она должна собрать Сильнейших этого мира и остановить Далилу — врага, угрожающего всему Зодиаку. Но чтобы это сделать, Терре придется принять участие в турнире Одиннадцати и встретиться с теми, кого она когда-то потеряла.\n\nНа арене решится не только судьба мира, но и ее собственная.\n\n...Если Терра не позволит дару Тельца сломать ее раньше.	2026	Альпина.Дети	Мая Сара	512
3	Капан	## О чем\nЭто виртуозное переплетение личных воспоминаний, вымысла и коллективной памяти, рассказанное с обезоруживающей откровенностью и неповторимым авторским стилем. Сквозь череду абсурдных ситуаций, трагических поворотов и комических эпизодов перед читателем разворачивается многоголосая хроника семьи, живущей на перекрестке времен и культур. Это смелая, одновременно жесткая и лиричная сага, заставляющая смеяться и плакать, удивляться и задумываться о том, как наши корни определяют нас.	2025	Альпина.Проза	Сероб Хачатрян	400
4	Вегетация	## О чем\nВ этот раз Алексей Иванов обратился к фантастике. Бригада лесорубов на вездеходе пробирается по лесным чащобам Урала к заброшенному военному объекту в таинственной горе Ямантау. А мир вокруг — вроде наш, но как-то не совсем... География реальна, однако посёлки и городишки — пустые, заводы — мёртвые, дороги заросли деревьями. И главное — изменился сам лес. Его вегетация искусственно ускорена для добычи древесины, и лес мутировал. Он живёт своей жизнью. Он ополчился на цивилизацию: в его дебрях скрываются чумоходы — обезумевшие машины и люди здесь теряют свою биологическую природу. Впрочем, только ли биологическую?.. Бригады лесорубов не лучше окружающего их мира: они друг другу конкуренты и между ними — война.\n\n&gt; Лес расступился, и Митя увидел грандиозные комплексы доменных печей — словно ступенчатые храмы, затерянные в джунглях. На всех ярусах, на переплетениях конструкций торчали ёлочки и берёзки; с массивных балок и площадок свисали корни деревьев и волосатые пласты почвы. Чудилось, домны ухнули в прошлое на столетие, но этого никак не могло быть. Вид индустриального величия, такого сложного в своём предназначении, а теперь бессмысленного, будто забытая клинопись, поражал воображение. Лес, точно океан, топил достижения цивилизации, и казалось, что это распад существования, что простота неумолимо поглощает сложность. Но Митя знал, что на самом деле всё не так. Это не лес вырос на заводе, а многомерность вбирала в себя то, что ограничено лишь тремя измерениями.\n\nРоман «Вегетация» построен по канонам многих жанров. Это роуд-муви — история путешествия, одиссея. Это постап — постапокалипсис. Это дизельпанк в российской глухомани. Это крепкий сай-фай — научная фантастика. Видовое разнообразие антиутопий подобно мутагенному лесу, однако «Вегетация» рассказывает не о том, куда едут герои, а о том, куда идём мы сами.\n\nНевежество — когда не хватает знаний. Но лесорубам знаний-то вполне хватает! Среднее образование никто не отменял! Просто в осмыслении мира приоритеты задаёт антропология! И она не позволяет принять истину, даже если её тебе в харю тычут.	2025	 Альпина.Проза	Алексей Викторович Иванов	536
5	Ближе к звездам	## О чем\nСкайлер знает о космосе все. Она одержима мечтой завершить исследование погибшей матери о нейтронных звездах и хочет попасть в программу НАСА. Правда, для этого необходима идеальная видеозаявка, а Скай сильна только в науке. Приходится обратиться за помощью к незнакомому парню — талантливому оператору по имени Купер. А еще нужно врать отцу, который панически боится потерять дочь так же, как потерял жену.\n\nПока Скай грезит о космосе, реальность преподносит сюрпризы: отец встречает новую любовь, Купер становится больше чем другом, а его младшая сестренка внезапно убегает из дома. Оказывается, что человеческие отношения посложнее квантовой физики. И никто не предупреждал, как больно выбирать между мечтой всей жизни и людьми, которые эту жизнь наполняют смыслом.	2026	 Маршмеллоу Букс	Кристин Уэбб	320
6	Щучьи сплетни	### О чем\nЖурналистка Варя Осокина едет на Русский Север — писать материал о восстановлении заброшенной церкви на острове, окруженном рукавами реки Онеги. Но внутри самой Вари — выжженная земля. Четыре года назад она потеряла отца и до сих пор не оправилась от горя.\n\nВ туманах холодной реки реальность дает трещину. Здесь щуки нашептывают о потаенных страхах, а из темных вод выходит русалка с заманчивым предложением. Варя хватается за него не раздумывая и слишком поздно осознает, что у этой сделки есть двойное дно, а плата за избавление от боли может оказаться слишком велика.\n\nТребования русалки становятся все изощреннее, и Варе приходится решить: поддаться коварному течению или найти свой якорь среди живых.	2024	Маршмеллоу Букс	Ольга Власенко	320
7	Мастер и Маргарита	### О чем\nЭто история о том, как однажды весной в Москву является сам дьявол со своей свитой, чтобы устроить великий бал и навсегда изменить судьбы гениального писателя, затравленного критикой, и его бесстрашной возлюбленной.\n\nПосмотрите, что случится, если дьявол приедет в Москву. Сатирический, мистический и невероятно смешной роман, где говорящие коты пьют водку, а сеансы чёрной магии срывают покровы с людских пороков. Проследите за великой историей любви Мастера и Маргариты. Это рассказ о всепобеждающей верности, самопожертвовании и о том, что настоящая любовь сильнее страха и даже смерти. Прочитайте роман внутри романа. Погрузитесь в древний Ершалаим и станьте свидетелем суда Понтия Пилата над Иешуа — мощной философской притчи о трусости, власти и истине.	2022	Альпина.Дети	Михаил Булгаков	528
8	Преступление и наказание	### О чем\nЭто история о том, как одна теория о «сверхчеловеке» разбивается о реальность. Читай, если готов погрузиться в разум гениального, но заблудшего студента, где главная битва разворачивается не на улицах, а в его собственной душе.\n\nПсихологический триллер XIX века — вы не просто наблюдаете за преступлением, а погружаетесь в сознание убийцы. Все муки совести, страх, самообман и лихорадочный поиск оправдания разворачиваются прямо у вас в голове.\n\nФилософия на грани жизни и смерти — книга ставит один из самых страшных вопросов: «Тварь ли я дрожащая или право имею?». Это исследование границ морали, цены человеческой жизни и того, что отделяет обычного человека от «сверхчеловека».\n\nПетербург как действующее лицо: душные, жёлтые, давящие улицы города — это не просто фон. Это полноценный персонаж, который сводит с ума, толкает на преступление и становится живым отражением внутреннего ада героев.	2023	Альпина.Дети	Фёдор Достоевский	704
9	Ночной страж	### О чем\nАмерика, 1874 год. На дорогах еще недавно охваченной Гражданской войной страны пересекаются судьбы мирных жителей и солдат, бродяг и беглецов. Двенадцатилетняя КонаЛи вынуждена отправиться в путь с матерью, которая не разговаривает уже больше года. Выдавая себя за леди и служанку, они находят убежище в лечебнице для душевнобольных. Покой обитателей в этих стенах оберегает израненный, потерявший память солдат — Ночной Страж.\n\nРоман Джейн Энн Филлипс, удостоенный Пулитцеровской премии, — не только пронзительная историческая драма, но и гимн милосердию и глубокое осмысление уязвимости и стойкости женщин в оглушенном насилием мире. Сочетая поэтичность языка с точностью документальной хроники, писательница исследует хрупкость человеческого духа и раскрывает исцеляющую силу сострадания.	2024	 Альпина Паблишер	Джейн Энн Филлипс	420
10	Спасая Винсента	### О чем\nПосле свадьбы не проходит и двух лет, как Йоханна Ван Гог остается одна с новорожденным сыном на руках. Смерть мужа Тео приносит ей горькое наследство: пустой банковский счет и сотни картин деверя Винсента, которого современники клеймят радикалом и создателем безобразного. Вместо того чтобы смириться с судьбой безутешной вдовы, Йо бросает вызов традициям и решает продвигать творчество опального художника. В ее руках письма Винсента, полные радости, отчаяния и искренней уязвимости, становятся главным ключом к пониманию его таланта. Но изобретательность и упорство молодой женщины сталкиваются с сопротивлением влиятельного парижского арт-дилера. Йоханна Ван Гог, обладавшая исключительным чутьем, пошла наперекор всем, чтобы сохранить полотна Винсента и сделать их достоянием всего мира. Художник, не продавший при жизни ни одной картины, встал в один ряд с Леонардо, Микеланджело, Рембрандтом, Моне и Пикассо.	2025	Альпина Паблишер	Джоан Фернандес	534
11	Кулачок	### О чём книга «Кулачок»\nПовесть «Кулачок» — это история первой любви. Старшеклассники Варя и Лева познакомились на даче. Впереди — целое лето. А за ним — такая непредсказуемая взрослая жизнь с ее обидами, ссорами, ревностью. Смогут ли они сберечь свои чувства, запечатленные на страницах дневников?	2021	Маршмеллоу Букс	Анна Гришина	144
12	Время обнимать	### О чём книга «Время обнимать»\nУвлекательная семейная сага и философская драма — о сложных судьбах, страсти, разлуке, трагической слепоте родных людей и их внезапных прозрениях, о цене жизни и смерти, о том, как прошлое настигает и убивает. И одновременно — гимн семье: объятиям, сантиментам, милым пустякам и взаимной любви, ее единственной нерушимой основе.\n\nС мягкой иронией автор рассказывает о питерской интеллигенции, трогательной заботе о «своем круге» и непременном культурном образовании детей, о любви к литературе и неприятии хамства.	2021	Альпина.Проза	Елена Минкина-Тайчер	330
\.


--
-- TOC entry 3070 (class 0 OID 16846)
-- Dependencies: 208
-- Data for Name: book_genre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.book_genre (book_id, genre_id) FROM stdin;
2	5
2	6
3	5
4	1
5	3
5	4
6	3
7	7
8	7
9	3
10	5
11	3
12	3
13	1
\.


--
-- TOC entry 3072 (class 0 OID 16863)
-- Dependencies: 210
-- Data for Name: cover; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cover (id, filename, mime_type, md5_hash, book_id) FROM stdin;
2	2.png	image/png	35edfe3a3f291adfe671071e0c6ee360	2
3	3.jpg	image/jpeg	1820dd86489ade64037fd40d83859478	3
4	4.jpg	image/jpeg	84d19846176eebbbb4d735ae56c12560	4
5	5.jpg	image/jpeg	6f03c4da7a83c47ff48354fa3a392d78	5
6	6.jpg	image/jpeg	c77046d761f5ec36733d43b6a70dba6c	6
7	7.jpg	image/jpeg	fe1ad221f40cfe46441f7b95dde332a1	7
8	8.jpg	image/jpeg	c7ae2cf8c5b83fa80f61d19011bf71e0	8
9	9.jpg	image/jpeg	6b3082193b2f4a2ac81216bb266c3e06	9
10	10.jpg	image/jpeg	a8c658bfaced1786727543a8a8d09a2e	10
11	11.jpg	image/jpeg	37ab5ab5517b7b7ab5eb92df6fbdd833	11
12	12.jpg	image/jpeg	9d03454319a174b2c01bc093c519973b	12
13	13.jpg	image/jpeg	7f563340160d1b71c2dafc6af3a12603	13
\.


--
-- TOC entry 3063 (class 0 OID 16804)
-- Dependencies: 201
-- Data for Name: genre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genre (id, name) FROM stdin;
1	Фантастика
2	Детектив
3	Роман
4	Наука
5	Поэзия
6	Приключения
7	Классика
\.


--
-- TOC entry 3076 (class 0 OID 16894)
-- Dependencies: 214
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review (id, book_id, user_id, rating, text, created_at, status_id) FROM stdin;
3	5	9	4	Рецензия на книгу "Ближе к звездам"	2026-06-15 11:24:20.796306	1
4	4	9	3	Слишком много страниц	2026-06-15 11:26:44.449287	1
5	7	9	5	Ну это классика	2026-06-15 11:27:05.497828	1
6	2	10	5	Это моя рецензия	2026-06-15 11:27:56.196871	1
8	10	10	4	Просто рецензия	2026-06-15 11:28:21.930298	1
2	2	9	5	**Интересная** *книга*	2026-06-15 11:23:20.008862	2
11	3	11	1	Текст рецензии	2026-06-15 11:29:25.195637	2
12	9	11	3	Текст рецензии	2026-06-15 11:29:37.245449	2
13	7	11	4	Просто рецензия	2026-06-15 11:29:48.980061	2
10	2	11	5	Моя рецензия	2026-06-15 11:29:00.662664	2
9	4	10	4	Ок	2026-06-15 11:28:31.363795	2
7	5	10	2	Еще одна рецензия	2026-06-15 11:28:11.079456	2
14	10	9	1	Рецензия для отказа	2026-06-15 11:40:44.299098	3
15	13	9	0	ыаоптвашпвао	2026-06-15 11:42:58.967288	1
\.


--
-- TOC entry 3069 (class 0 OID 16838)
-- Dependencies: 207
-- Data for Name: review_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review_status (id, name) FROM stdin;
1	на рассмотрении
2	одобрена
3	отклонена
\.


--
-- TOC entry 3067 (class 0 OID 16825)
-- Dependencies: 205
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role (id, name, description) FROM stdin;
1	администратор	Полный доступ
2	модератор	Редактирование книг и модерация рецензий
3	пользователь	Может оставлять рецензии
\.


--
-- TOC entry 3074 (class 0 OID 16876)
-- Dependencies: 212
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, login, password_hash, last_name, first_name, middle_name, role_id) FROM stdin;
9	user1	pbkdf2:sha256:600000$gzcWnKGgAnMFOjoI$71c0f8b14e79b0c51af119b216ee00c06f5ee67f00ecc2c819610601b43bb3ed	Иванов	Иван	Иванович	3
10	user2	pbkdf2:sha256:600000$ggfQ5sO3LLBoDFLl$4fdf5c552d7d51dd9fc1adee007970347640c563a99150edd0a5718517e2ad9f	Петрова	Анна	Сергеевна	3
11	user3	pbkdf2:sha256:600000$8UP4gK3GqdndraTy$c471fc72f94eec3a0c6f1097bfb0c0ad1fa9321e9770bda05a3d461243d373aa	Сидоров	Пётр	Алексеевич	3
12	user4	pbkdf2:sha256:600000$8a6PPFJZNjDbZb9q$507e93250d055fc9e67d376e5c47e90e1e3bec38ec46c95681645409b5577adc	Козлова	Елена	Дмитриевна	3
13	user5	pbkdf2:sha256:600000$c8RzOKPpMJMh1n05$3ff030e27398bf0ae60c2fdb483fdf6d1f9ea2a41bfdf4d3efaed3977d394246	Смирнов	Алексей	Владимирович	3
14	moderator	pbkdf2:sha256:600000$OLF1PNPed1hyWh4l$4cc12847e63a09e9d81efc32eab4f526bcc8418659b750700d243b2138b6ffa6		Модератор		2
15	admin	pbkdf2:sha256:600000$JGWzxYdgg1zc87LP$ea3e38308f099ff720e06b57b12db182f42eda3ae0e79755f1d30eb9f5ca815f		Администратор		1
\.


--
-- TOC entry 3089 (class 0 OID 0)
-- Dependencies: 202
-- Name: book_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.book_id_seq', 13, true);


--
-- TOC entry 3090 (class 0 OID 0)
-- Dependencies: 209
-- Name: cover_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cover_id_seq', 13, true);


--
-- TOC entry 3091 (class 0 OID 0)
-- Dependencies: 200
-- Name: genre_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genre_id_seq', 7, true);


--
-- TOC entry 3092 (class 0 OID 0)
-- Dependencies: 213
-- Name: review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_id_seq', 15, true);


--
-- TOC entry 3093 (class 0 OID 0)
-- Dependencies: 206
-- Name: review_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_status_id_seq', 3, true);


--
-- TOC entry 3094 (class 0 OID 0)
-- Dependencies: 204
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_id_seq', 3, true);


--
-- TOC entry 3095 (class 0 OID 0)
-- Dependencies: 211
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 15, true);


--
-- TOC entry 2916 (class 2606 OID 16850)
-- Name: book_genre book_genre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_genre
    ADD CONSTRAINT book_genre_pkey PRIMARY KEY (book_id, genre_id);


--
-- TOC entry 2906 (class 2606 OID 16822)
-- Name: book book_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_pkey PRIMARY KEY (id);


--
-- TOC entry 2918 (class 2606 OID 16868)
-- Name: cover cover_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cover
    ADD CONSTRAINT cover_pkey PRIMARY KEY (id);


--
-- TOC entry 2902 (class 2606 OID 16811)
-- Name: genre genre_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_name_key UNIQUE (name);


--
-- TOC entry 2904 (class 2606 OID 16809)
-- Name: genre genre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_pkey PRIMARY KEY (id);


--
-- TOC entry 2924 (class 2606 OID 16902)
-- Name: review review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id);


--
-- TOC entry 2912 (class 2606 OID 16845)
-- Name: review_status review_status_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_status
    ADD CONSTRAINT review_status_name_key UNIQUE (name);


--
-- TOC entry 2914 (class 2606 OID 16843)
-- Name: review_status review_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_status
    ADD CONSTRAINT review_status_pkey PRIMARY KEY (id);


--
-- TOC entry 2908 (class 2606 OID 16835)
-- Name: role role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_name_key UNIQUE (name);


--
-- TOC entry 2910 (class 2606 OID 16833)
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- TOC entry 2920 (class 2606 OID 16886)
-- Name: user user_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_login_key UNIQUE (login);


--
-- TOC entry 2922 (class 2606 OID 16884)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2925 (class 2606 OID 16851)
-- Name: book_genre book_genre_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_genre
    ADD CONSTRAINT book_genre_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(id) ON DELETE CASCADE;


--
-- TOC entry 2926 (class 2606 OID 16856)
-- Name: book_genre book_genre_genre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_genre
    ADD CONSTRAINT book_genre_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.genre(id) ON DELETE CASCADE;


--
-- TOC entry 2927 (class 2606 OID 16869)
-- Name: cover cover_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cover
    ADD CONSTRAINT cover_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(id) ON DELETE CASCADE;


--
-- TOC entry 2929 (class 2606 OID 16903)
-- Name: review review_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(id) ON DELETE CASCADE;


--
-- TOC entry 2931 (class 2606 OID 16913)
-- Name: review review_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.review_status(id);


--
-- TOC entry 2930 (class 2606 OID 16908)
-- Name: review review_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- TOC entry 2928 (class 2606 OID 16887)
-- Name: user user_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.role(id);


-- Completed on 2026-06-15 12:00:44

--
-- PostgreSQL database dump complete
--

