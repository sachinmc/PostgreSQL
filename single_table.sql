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
