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
WHERE email LIKE '%teleworm.us'
