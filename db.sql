CREATE TYPE public.seniorityLevelType AS ENUM ('jun', 'middle', 'senior', 'lead');

CREATE TABLE public.employees (
                                        id bigint NOT NULL,
                                        fio character varying (255),
                                        birthday timestamp without time zone,
                                        start_date timestamp without time zone,
                                        position character varying (255),
                                        seniority_level seniorityLevelType,
                                        salary bigint, -- уровень ЗП в мин. единицах валюты (ex. коп. для РФ, центы для US)
                                        dep_id character varying (16),
                                        perms boolean default false
);
ALTER TABLE public.employees OWNER TO de;
CREATE SEQUENCE public.employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.employees_id_seq OWNER TO de;
ALTER SEQUENCE public.employees_id_seq OWNED BY employees.id;
ALTER TABLE ONLY public.employees ADD CONSTRAINT employees_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


CREATE TABLE public.deps (
                                        id character varying (16) NOT NULL PRIMARY KEY,
                                        name character varying (255),
                                        head_name character varying (255),
                                        employee_count integer
);

CREATE TYPE public.scoreType AS ENUM ('A', 'B', 'C', 'D', 'E');

CREATE TABLE public.scores (
                                        employee_id bigint NOT NULL,
                                        score scoreType NOT NULL,
                                        q integer NOT NULL,
                                        year integer NOT NULL
);

-- Fill deps
insert into deps values ('IT', 'IT Department', 'Багов Григорий Багович', '12');
insert into deps values ('DevOps', 'DevOps Department', 'Докеров Кубернейт Платформович', '22');
insert into deps values ('IDA', 'Интеллектуального анализа данных', 'Интеллектуалов Интеллект Анализович', '3');

-- Fill employees
insert into employees (fio, birthday, start_date, position, seniority_level, salary, dep_id, perms) values (
'Иванов Иван Иванович', '1988-12-12', '2000-01-01', 'Architect', 'senior', '30000000', 'IT', false
);
insert into employees (fio, birthday, start_date, position, seniority_level, salary, dep_id, perms) values (
'Багов Григорий Багович', '1387-01-11', '1917-05-06', 'Head of Department', 'lead', '800000000', 'IT', false
);
insert into employees (fio, birthday, start_date, position, seniority_level, salary, dep_id, perms) values (
'Докеров Кубернейт Платформович', '1837-06-02', '1844-03-02', 'Head of Department', 'lead', '800000000', 'DevOps', true
);
insert into employees (fio, birthday, start_date, position, seniority_level, salary, dep_id, perms) values (
'Эпикфейлов Фейл Фейлович', '2000-08-02', '2010-04-04', 'Coder', 'jun', '100000', 'IT', false
);
insert into employees (fio, birthday, start_date, position, seniority_level, salary, dep_id, perms) values (
'Накатов Деплой Гитлабович', '1970-09-12', '2000-02-02', 'Dev Ops', 'middle', '10000000', 'DevOps', false
);
insert into employees (fio, birthday, start_date, position, seniority_level, salary, dep_id, perms) values (
'Интеллектуалов Интеллект Анализович', '1975-10-11', '2022-01-01', 'Head Of Department', 'lead', '1000000000', 'IDA', true
);
insert into employees (fio, birthday, start_date, position, seniority_level, salary, dep_id, perms) values (
'Аналитиков Аналит Даннович', '1990-11-12', '2022-01-01', 'Analyst', 'lead', '20000000', 'IDA', false
);
insert into employees (fio, birthday, start_date, position, seniority_level, salary, dep_id, perms) values (
'Джунов Юниор Студентович', '1999-12-03', '2022-01-01', 'Student', 'jun', '200000', 'IDA', false
);
insert into employees (fio, birthday, start_date, position, seniority_level, salary, dep_id, perms) values (
'Пазиков Паз Пазович', '1983-11-02', '2020-01-01', 'Driver', 'jun', '200000', 'IT', false
);
insert into employees (fio, birthday, start_date, position, seniority_level, salary, dep_id, perms) values (
'Уазиков Уаз Уазович', '1976-10-01', '2018-02-03', 'Driver', 'jun', '250000', 'IT', false
);

-- Fill scores
insert into scores values (1, 'D', 2000, 1);
insert into scores values (1, 'A', 2001, 2);
insert into scores values (1, 'E', 2002, 3);
insert into scores values (2, 'E', 2002, 3);

select * from employees;

-- Queries
SELECT id, fio, DATE_PART('year', NOW()) - DATE_PART('year', start_date) as experience FROM employees;
SELECT id, fio, DATE_PART('year', NOW()) - DATE_PART('year', start_date) as experience FROM employees LIMIT 3;
SELECT id FROM employees WHERE position = 'Driver';
SELECT id FROM employees e WHERE e.id IN (SELECT employee_id FROM scores WHERE score IN ('D', 'E'));
SELECT salary FROM employees ORDER BY salary DESC LIMIT 1;

SELECT name FROM deps ORDER BY employee_count DESC LIMIT 1;
SELECT id FROM employees ORDER BY start_date ASC;
