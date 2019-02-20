/*

-----------------------------------------------------------

School : Acme Inc
Class  : DAW_1
Teacher: Jonh Doe
Student: Berto

-----------------------------------------------------------

Exam instructions:

* Create a new database using the provided file schema.sql.
* Copy this file and nombre it <your_nombre.sql>.
* Open the file <your_nombre.sql> and answer to each
  question in the gaps provided.
* Save it frequently to avoid data loss.
* When you have finished provide the file <your_nombre.sql>
  to the teacher.

-----------------------------------------------------------

*/


--------------------------------------------------------------------------------
--> TOTAL SCORE: 3.65
--------------------------------------------------------------------------------

--> 1
--> Score: 0.5
--> Feedback: No puedes usar 'ventas' como nombre porque has usado una alias. Debes usar orden DESCendente
/*

1. Get a ventas list ordered in such a way the most
recent sale is shown first.
Include columns:
 - date
 - cliente first nombre
 - cliente last nombre
 - producto nombre
 - cantidad

*/
--> Answer:
SELECT fecha, nombre, apellidos, nombre, cantidad
FROM ventas s join producto p on s.producto_id = p.id
join cliente c on c.id = ventas.cliente_id
ORDER BY fecha;


--> 2
--> Score: 0.9
--> Feedback: 'Poppies', no 'Popies'
/*

2. Añade un nuevo producto con estos datos:
 - Nombre  = Birthday Card Red Poppies
 - Precio = 2.49

*/
--> Answer:
INSERT INTO producto (nombre, precio)
VALUES ('Birthday Card Red Popies', 2.49);


--> 3
--> Score: 1.0
--> Feedback: Bien
/*

Muestra el nombre del producto más caro.

*/
--> Answer:
SELECT nombre
FROM producto
ORDER BY precio DESC
LIMIT 1;


--> 4
--> Score: 0.25
--> Feedback: sum(s.cantidad) en lugar de count(s.cantidad)
/*

¿Que producto se ha vendido más veces?
Muestra las columnas:
 - Nombre del producto
 - Número de ventas
 - Cantidad vendida

*/
--> Answer:
SELECT p.nombre, count(s.id), count(s.cantidad)
FROM ventas s join producto p on p.id = s.producto_id
GROUP BY p.nombre
ORDER BY count(s.cantidad) DESC
LIMIT 1;


--> 5
--> Score: 1.0
--> Feedback: Bien
/*

Actualiza los productos Casio para que el nombre del
'Casio' instead of 'CASIO'.

*/
--> Answer:
UPDATE producto SET nombre = replace(nombre, 'CASIO', 'Casio') WHERE nombre like '%casio%';


