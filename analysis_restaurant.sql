/* create table Restaurant 5 tables
1x fact 4x dimensions
GG how to add FK to the table
write SQL 3-5 queries
1x subquery / with
*/

-- 1 Dimension table - customers
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  first_name varchar(20),
  last_name varchar(20),
  gender varchar(5)
);

INSERT INTO customers VALUES
  (1, 'Tom', 'Mood', 'M'),
  (2, 'Marry', 'Hogie', 'F'),
  (3, 'Jane', 'Fessy', 'F'),
  (4, 'Evan', 'Wats', 'M'),
  (5, 'Anne', 'Bell', 'F'),
  (6, 'Harry', 'Stain', 'M'),
  (7, 'Lilly', 'Mag', 'F'),
  (8, 'Emma', 'Foxxe', 'F'),
  (9, 'Sam', 'Manuel', 'M'),
  (10, 'Billy', 'Rose', 'F');

-- 2 Dimension table - staff
CREATE TABLE staff (
  staff_id varchar(4) PRIMARY KEY,
  name varchar(20),
  phone varchar(14)
);

INSERT INTO staff VALUES
  ('S001', 'Amy', '084-452-2455'),
  ('S002', 'Philips', '086-345-0797'),
  ('S003', 'Max', '081-769-5959');

-- 3 Dimension table - promotion
CREATE TABLE promotion (
  promotion_id varchar(4) PRIMARY KEY,
  description varchar(200),
  discount INT
);

INSERT INTO promotion values
  ('PR01', 'Order amount over 1000 get discount 100', 100),
  ('PR02', 'Order amount over 500 get discount 50', 50);

-- 4 Dimension table - menu
CREATE TABLE menu (
  menu_id INT PRIMARY KEY,
  name varchar(50),
  price REAL
);

INSERT INTO menu VALUES
  (1, 'Steak', 999),
  (2, 'Soup', 99),
  (3, 'Fried rice', 299),
  (4, 'Fried chicken', 199),
  (5, 'Water', 19),
  (6, 'Beer', 39);

-- 1 Fact table
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  order_date date,
  customer_id INT,
  menu_id INT,
  quantity INT,
  amount REAL,
  promotion_id varchar(4),
  discount REAL,
  total REAL,
  staff_id varchar(4),
  FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
  FOREIGN KEY (menu_id) REFERENCES menu(menu_id),
  FOREIGN KEY (promotion_id) REFERENCES promotion(promotion_id),
  FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

INSERT INTO orders VALUES
  (1, '2022-08-01', 1, 1, 2, 1998, 'PR01', 100, 1898, 'S003'),
  (2, '2022-08-01', 1, 5, 3, 57, Null, 0, 57, 'S002'),
  (3, '2022-08-01', 3, 3, 5, 1495, 'PR01', 100, 1395, 'S001'),
  (4, '2022-08-02', 4, 4, 3, 597, 'PR02', 50, 547, 'S002'),
  (5, '2022-08-02', 5, 2, 1, 99, NULL, 0, 99, 'S002'),
  (6, '2022-08-02', 2, 3, 2, 598, 'PR02', 50, 548, 'S003'),
  (7, '2022-08-03', 7, 1, 1, 999, 'PR02', 50, 949, 'S003'),
  (8, '2022-08-03', 8, 4, 4, 796, 'PR02', 50, 746, 'S001'),
  (9, '2022-08-03', 9, 1, 3, 2997, 'PR01', 100, 2897, 'S002'),
  (10, '2022-08-04', 8, 5, 3, 57, NULL, 0, 57, 'S001'),
  (11, '2022-08-04', 10, 6, 10, 390, NULL, 0, 390, 'S003'),
  (12, '2022-08-04', 4, 4, 6, 1194, 'PR01', 100, 1094, 'S002'),
  (13, '2022-08-05', 1, 3, 2, 598, 'PR02', 50, 548, 'S001'),
  (14, '2022-08-06', 6, 4, 10, 1990, 'PR01', 100, 1890, 'S002'),
  (15, '2022-08-06', 6, 6, 5, 195, NULL, 0, 195, 'S002');

.mode markdown
.header on

-- 1 queries: total order from customer gender M 
SELECT
  gender,
  COUNT(*) AS n_order_cus_m,
  SUM(total) AS total_amount_cus_m
FROM  
  (SELECT *
  FROM customers
  JOIN orders ON customers.customer_id = orders.customer_id
  WHERE gender = 'M');

-- 2 queries: total orders
SELECT
  m.name AS menu_name,
  SUM(o.quantity) AS total_order,
  SUM(o.total) AS total_amount
FROM orders AS o
JOIN menu AS m ON o.menu_id = m.menu_id
GROUP BY m.name
ORDER BY SUM(o.quantity) DESC;

-- 3 queries: group by food, drinks
WITH sub AS (
  SELECT
   menu_id,
   name,
  CASE 
    WHEN name IN ('Steak','Soup', 'Fried rice', 'Fried chicken') THEN 'Food'
    WHEN name IN ('Water', 'Beer') THEN 'Drinks'
  ELSE 'None'
  END AS type
  FROM menu
)

SELECT
  s.type,
  SUM(o.quantity) AS total_order,
  SUM(o.total) AS total_amount
FROM orders AS o
JOIN sub AS s ON o.menu_id = s.menu_id
GROUP BY s.type;

-- 4 queries: total sell per day
SELECT 
  order_date,
  CASE CAST (STRFTIME('%w', order_date) AS INT)
    WHEN 0 THEN 'Sun'
    WHEN 1 THEN 'Mon'
    WHEN 2 THEN 'Tue'
    WHEN 3 THEN 'Wed'
    WHEN 4 THEN 'Thu'
    WHEN 5 THEN 'Fri'
  ELSE 'Sat' END AS weekday,
  SUM(total) AS total_amount
FROM orders
GROUP BY order_date
ORDER BY SUM(total) DESC;

-- 5 queries: discount per customer
SELECT
  c.first_name || ' ' || c.last_name AS customer_name,
  SUM(o.discount) AS total_discount
FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
GROUP BY 1
ORDER BY 2 DESC
