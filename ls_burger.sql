CREATE TABLE orders (
  id serial,
  customer_name varchar(100) NOT NULL,
  burger varchar(50),
  side varchar(50),
  drink varchar(50),
  customer_email varchar(50),
  customer_loyalty_points integer DEFAULT 0,
  burger_cost decimal(4,2) DEFAULT 0,
  side_cost decimal(4,2) DEFAULT 0,
  drink_cost decimal(4,2) DEFAULT 0
);

INSERT INTO orders (customer_name, customer_email, burger, side, drink, burger_cost,
  side_cost, drink_cost, customer_loyalty_points)
  VALUES ('James Bergman', 'james1998@email.com', 'LS Chicken Burger', 'Fries',
  'Cola', 4.50, 0.99, 1.50, 28),
  ('Natasha O''Shea', 'natasha@osheafamily.com', 'LS Cheese Burger', 'Fries',
  NULL, 3.50, 0.99, DEFAULT, 18),
  ('Natasha O''Shea', 'natasha@osheafamily.com', 'LS Double Deluxe Burger', 'Onion Rings',
  'Chocolate Shake', 6.00, 1.50, 2.00, 42),
  ('Aaron Muller', NULL, 'LS Burger', NULL,
    NULL, 3.00, DEFAULT, DEFAULT, 10);
