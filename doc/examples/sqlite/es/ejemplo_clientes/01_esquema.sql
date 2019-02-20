/*

  Base de datos extremadamente simple.

*/
-- Creacion de tablas
CREATE TABLE cliente (
  id         integer primary key,
  nombre     text,
  apellidos  text
);

CREATE TABLE producto (
  id         integer primary key,
  nombre     text,
  precio      real
);

CREATE TABLE ventas (
  id           integer primary key,
  cliente_id   integer,
  producto_id  integer,
  cantidad     integer,
  fecha        text,
  FOREIGN KEY (cliente_id) REFERENCES cliente(id),
  FOREIGN KEY (producto_id) REFERENCES producto(id)
);

-- Añadir datos
INSERT INTO cliente
  (nombre, apellidos)
VALUES
  ('Barry', 'Shmelly'),
  ('Bjorn', 'Free'),
  ('Casey', 'Deeya'),
  ('Doug', 'Graves'),
  ('Ellie', 'Noise'),
  ('Ken', 'Hardly')
;

INSERT INTO producto
  (nombre, precio)
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

INSERT INTO ventas
  (cliente_id, producto_id, cantidad, fecha)
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
