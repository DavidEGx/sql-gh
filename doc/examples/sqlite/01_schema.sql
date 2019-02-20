/*

  Very simple database.

*/
-- Create tables
CREATE TABLE customer (
  id        integer primary key,
  firstname text,
  lastname  text
);

CREATE TABLE product (
  id            integer primary key,
  name          text,
  price         real
);

CREATE TABLE sales (
  id            integer primary key,
  customer_id   integer,
  product_id    integer,
  quantity      integer,
  "date"        text,
  FOREIGN KEY (customer_id) REFERENCES customer(id),
  FOREIGN KEY (product_id) REFERENCES product(id)
);

-- Add data
INSERT INTO customer
  (firstname, lastname)
VALUES
  ('Barry', 'Shmelly'),
  ('Bjorn', 'Free'),
  ('Casey', 'Deeya'),
  ('Doug', 'Graves'),
  ('Ellie', 'Noise'),
  ('Ken', 'Hardly')
;

INSERT INTO product
  (name, price)
VALUES
  ('Papermate Blue Pen', 1.59),
  ('Papermate Black Pen', 1.59),
  ('Writing paper 100 sheets', 3.79),
  ('Moderno Notebook', 4.99),
  ('Moderno Bullet Journal', 7.99),
  ('Post-it notes (pack of 300)', 2.99),
  ('Post-it 10 slim sticky notes', 4.99),
  ('CASIO FX-991EX Scientific Calculator', 27.99),
  ('CASIO FX-CG50 Graphic Calculator', 119.99)
;

INSERT INTO sales
  (customer_id, product_id, quantity, "date")
VALUES
  (3, 5, 25, '2019-05-01'),
  (2, 1, 10, '2019-05-01'),
  (1, 3, 100, '2019-05-02'),
  (1, 1, 100, '2019-05-08'),
  (2, 1, 10, '2019-05-09'),
  (2, 3, 20, '2019-05-09'),
  (3, 5, 25, '2019-05-09'),
  (3, 2, 120, '2019-05-11'),
  (3, 8, 2, '2019-05-11'),
  (1, 7, 30, '2019-05-21'),
  (3, 1, 120, '2019-05-22'),
  (3, 9, 5, '2019-05-23'),
  (1, 8, 5, '2019-05-24'),
  (6, 2, 26, '2019-05-24')
;
