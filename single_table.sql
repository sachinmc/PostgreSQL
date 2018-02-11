CREATE TABLE people (
  name text,
  age int,
  occupation text
);

INSERT INTO people VALUES
  ('Abby', 34, 'biologist'),
  ('Mu''nisah', 26, NULL),
  ('Mirabelle', 40, 'contractor');


/* 3 sql queries to retrieve the second row of the table */

SELECT * FROM people
OFFSET 1 LIMIT 1;

SELECT * FROM people
WHERE name = 'Mu''nisah';

SELECT * FROM people
WHERE occupation IS NULL;

/*
*/

CREATE TABLE birds (
  name varchar(255),
  length real,
  wingspan real,
  family varchar(255),
  extinct boolean
);

INSERT INTO birds (name, length, wingspan, family, extinct) VALUES
  ('Spotted Towhee',	21.6,	26.7,	'Emberizidae',	'f'),
  ('American Robin',	25.5,	36.0,	'Turdidae',	'f'),
  ('Greater Koa Finch',	19.0,	24.0,	'Fringillidae',	't'),
  ('Carolina Parakeet',	33.0,	55.8,	'Psittacidae',	't'),
  ('Common Kestrel',	35.5,	73.5,	'Falconidae',	'f');

/* find names and families for all birds that are not extinct
in order from longest to shortest based on length column */

SELECT name, family FROM birds
WHERE extinct = 'f'
ORDER BY length DESC;


SELECT avg(wingspan), min(wingspan), max(wingspan), extinct FROM birds
GROUP BY extinct;


/*
*/

CREATE TABLE menu_items (
  item text,
  prep_time int,
  ingredient_cost numeric(3,2),
  sales int,
  menu_price numeric(3,2)
);

INSERT INTO menu_items VALUES
  ('omelette', 10,	1.50,	182,	7.99),
  ('tacos',	5,	2.00,	254,	8.99),
  ('oatmeal',	1,	0.50,	79,	5.99);

/*
which menu item is most profitable
based on cost of ingredient
*/

SELECT item, menu_price - ingredient_cost AS profit FROM menu_items
ORDER BY profit DESC
LIMIT 1;


/*
most profitable menu time based on prep time, $13/hr cost
*/

/* resulting table */

item   | menu_price | ingredient_cost | labor | profit
----------+------------+-----------------+-------+--------
tacos    |       8.99 |            2.00 |  1.08 |   5.91
oatmeal  |       5.99 |            0.50 |  0.22 |   5.27
omelette |       7.99 |            1.50 |  2.17 |   4.32


/* query */

SELECT item, menu_price, ingredient_cost, round(prep_time * (13.0/60), 2) AS labor,
  menu_price - ingredient_cost - round(prep_time * (13.0/60), 2) AS profit
  FROM menu_items
  ORDER BY profit DESC;


/* films1.sql */

INSERT INTO films VALUES
  ('1984',	1956,	'scifi',	'Michael Anderson',	90),
  ('Tinker Tailor Soldier Spy',	2011,	'espionage',	'Tomas Alfredson',	127),
  ('The Birdcage',	1996,	'comedy',	'Mike Nichols',	118);


/*
return title and age in years of each movie, with the newest movie listed first
*/

SELECT title, date_part('year', current_date) - year AS age FROM films
ORDER BY year DESC;

/* or */

SELECT title, extract(year from current_date) - year AS age FROM films
ORDER BY age ASC;

/*
Write a SQL statement that will return the title and duration of each movie
longer than two hours, with the longest movies first.
*/

SELECT title, duration FROM films
WHERE duration > 120
ORDER BY duration DESC;

/*
SQL statement that returns the title of the longest movie
*/

SELECT title FROM films
ORDER BY duration DESC
LIMIT 1;

/*
Write a SQL query to list the ten states with the most rows in the people table
in descending order.
*/

SELECT state, count(state) AS count FROM people
GROUP BY state ORDER BY count DESC LIMIT 10;

/* also */

SELECT state, COUNT(id) FROM people GROUP BY state ORDER BY count DESC LIMIT 10;


/*
Write a SQL query that lists each domain used in an email address in the
people table and how many people in the database have an email address
containing that domain. Domains should be listed with the most popular first.
*/


SELECT count(id), substring(email from '%@#"_+#"%' for '#') AS domain
  FROM people
  GROUP BY domain
  ORDER BY count(id) DESC;

/*
  residents=# SELECT count(id), substring(email from '%@#"_+#"%' for '#') AS domain
  residents-#   FROM people
  residents-#   GROUP BY domain
  residents-#   ORDER BY count(id) DESC;
   count |     domain
  -------+----------------
    1036 | cuvox.de
    1029 | gustr.com
    1024 | rhyta.com
    1018 | superrito.com
    1006 | armyspy.com
    1000 | jourrapide.com
     998 | teleworm.us
     966 | dayrep.com
     965 | einrot.com
     958 | fleckens.hu
  (10 rows)

  residents=#
*/

/*
Also this:
*/
SELECT substr(email, strpos(email, '@') + 1) as domain, COUNT(id) FROM people GROUP BY domain ORDER BY count DESC;


/*
Write a SQL statement that will update the given_name values to be all uppercase
for all users with an email address that contains teleworm.us.
*/
UPDATE people
SET given_name = upper(given_name)
WHERE email LIKE '%teleworm.us';


/*
Write the SQL statement to create a table called temperatures to hold the following data:

date	low	high
2016-03-01	34	43
2016-03-02	32	44
2016-03-03	31	47
2016-03-04	33	42
2016-03-05	39	46
2016-03-06	32	43
2016-03-07	29	32
2016-03-08	23	31
2016-03-09	17	28
Keep in mind that all rows in the table should always contain all three values.
*/

CREATE TABLE temperatures (
  date date NOT NULL,
  low int NOT NULL,
  high int NOT NULL
);

INSERT INTO temperatures VALUES
  ('2016-03-01',	34,	43),
  ('2016-03-02',	32,	44),
  ('2016-03-03',	31,	47),
  ('2016-03-04',	33,	42),
  ('2016-03-05',	39,	46),
  ('2016-03-06',	32,	43),
  ('2016-03-07',	29,	32),
  ('2016-03-08',	23,	31),
  ('2016-03-09',	17,	28);

/*
Write a SQL statement to determine the average (mean) temperature
for the days from March 2, 2016 through March 8, 2016.
*/

SELECT (high + low)/2 AS average, date FROM temperatures
  WHERE date >= '2016-03-02' AND date <= '2016-03-08';

/* or */

SELECT date, (high + low) / 2 as average
  FROM temperatures
 WHERE date BETWEEN '2016-03-02' AND '2016-03-08';

/*
Each day, it rains one millimeter for every degree the average temperature goes
above 35. Write a SQL statement to update the data in the table temperatures to
reflect this.
*/

UPDATE temperatures
SET rainfall = (high + low)/2 - 35
WHERE (high + low)/2 > 35;

/*
A decision has been made to store rainfall data in inches. Write the SQL
statements required to modify the rainfall column to reflect these new
requirements.
(25.4 mm make up an inch)
*/

ALTER TABLE temperatures
ALTER COLUMN rainfall TYPE numeric(4,3);

UPDATE temperatures
SET rainfall = trunc(rainfall/25.4, 3);

/* or */

ALTER TABLE temperatures ALTER COLUMN rainfall TYPE numeric(6,3);
UPDATE temperatures SET rainfall = rainfall * 0.039;

/*
The idea behind this dump method is to generate a file with SQL commands that,
when fed back to the server, will recreate the database in the same state as it
was at the time of the dump. PostgreSQL provides the utility program pg_dump for
this purpose. The basic usage of this command is:
*/

pg_dump dbname > outfile

/* from terminal */
$ pg_dump -d sql-course -t weather --inserts > dump.sql


/*
Add a constraint to films that requires all rows to have a value for director
that is at least 3 characters long and contains at least one space character ()
*/

ALTER TABLE films
ADD CHECK (length(director) >= 3 AND director LIKE '% %');

/* or */

ALTER TABLE films ADD CONSTRAINT director_name
CHECK (length(director) >= 3 AND position(' ' in director) > 0);



/*
Write SQL statements that will insert the following films into the database:

title	year	genre	director	duration
Wayne's World	1992	comedy	Penelope Spheeris	95
Bourne Identity	2002	espionage	Doug Liman	118
*/

INSERT INTO films VALUES
('Wayne''s World', 1992, 'comedy', 'Penelope Spheeris', 95),
('Bourne Identity', 2002, 'espionage', 'Doug Liman', 118);


/*
Write a SQL query that lists all genres for which there is a movie in
the films table.
*/

SELECT DISTINCT genre FROM films;

/* or */

SELECT genre FROM films
GROUP BY genre;


/* average time from all films, rounded value */
SELECT round(avg(duration)) AS average FROM films;


/*
Write a SQL query that determines the average duration for each genre in
the films table, rounded to the nearest minute.
*/

SELECT genre, round(avg(duration)) AS average_duration FROM films
GROUP BY genre;

/*
Write a SQL query that determines the average duration of movies for each
decade represented in the films table, rounded to the nearest minute and
listed in chronological order.
*/

SELECT year/10 * 10 AS decade, round(avg(duration))
FROM films GROUP BY decade ORDER BY decade;


sql_course=# SELECT * FROM films
WHERE director LIKE 'John%';
/*
 id |   title    | year | genre  |        director         | duration
----+------------+------+--------+-------------------------+----------
  1 | Die Hard   | 1988 | action | John McTiernan          |      132
 12 | Home Alone | 1990 | comedy | John Wilden Hughes, Jr. |      102
 13 | Hairspray  | 1988 | comedy | John Waters             |       92
(3 rows)
*/


sql_course=# SELECT genre, count(id) FROM films
GROUP BY genre ORDER BY count DESC;

/*
   genre   | count
-----------+-------
 scifi     |     5
 comedy    |     4
 drama     |     2
 espionage |     2
 crime     |     1
 horror    |     1
 thriller  |     1
 action    |     1
(8 rows)
*/


/*  SQL query that will return the following data: */

sql_course=# SELECT year/10 * 10 AS decade, genre, string_agg(title, ', ') AS films
sql_course-# FROM films
sql_course-# GROUP BY decade, genre
sql_course-# ORDER BY decade;

/*
 decade |   genre   |                  films
--------+-----------+------------------------------------------
   1940 | drama     | Casablanca
   1950 | drama     | 12 Angry Men
   1950 | scifi     | 1984
   1970 | crime     | The Godfather
   1970 | thriller  | The Conversation
   1980 | action    | Die Hard
   1980 | comedy    | Hairspray
   1990 | comedy    | Home Alone, The Birdcage, Wayne's World
   1990 | scifi     | Godzilla
   2000 | espionage | Bourne Identity
   2000 | horror    | 28 Days Later
   2010 | espionage | Tinker Tailor Soldier Spy
   2010 | scifi     | Midnight Special, Interstellar, Godzilla
(13 rows)

sql_course=#
*/

sql_course=# SELECT genre, sum(duration) AS total_duration
sql_course-# FROM FILMS
sql_course-# GROUP BY genre
sql_course-# ORDER BY total_duration;

/*
   genre   | total_duration
-----------+----------------
 thriller  |            113
 horror    |            113
 action    |            132
 crime     |            175
 drama     |            198
 espionage |            245
 comedy    |            407
 scifi     |            632
(8 rows)

sql_course=#
*/
