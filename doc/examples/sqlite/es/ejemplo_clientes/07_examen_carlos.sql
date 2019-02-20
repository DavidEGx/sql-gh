/*

-----------------------------------------------------------

School : Acme Inc
Class  : DAW_1
Teacher: Jonh Doe
Student: Carlos

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
--> TOTAL SCORE: 2.0
--------------------------------------------------------------------------------

--> 1
--> Score: 0.75
--> Feedback: Solo debes mostrar las columnas pedidas
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
SELECT * FROM producto left join ventas on producto.id = ventas.producto_id
ORDER BY ventas.date DESC;


--> 2
--> Score: 1.0
--> Feedback: Bien
/*

2. Añade un nuevo producto con estos datos:
 - Nombre  = Birthday Card Red Poppies
 - Precio = 2.49

*/
--> Answer:
INSERT INTO producto (nombre, precio) VALUES ('Birthday Card Red Poppies', 2.49);


--> 3
--> Score: 0.0
--> Feedback: Tenías que mostrar el nombre del producto, no el precio
/*

Muestra el nombre del producto más caro.

*/
--> Answer:
SELECT max(precio) FROM producto;


--> 4
--> Score: 0.0
/*

¿Que producto se ha vendido más veces?
Muestra las columnas:
 - Nombre del producto
 - Número de ventas
 - Cantidad vendida

*/
--> Answer:
SELECT * FROM producto join ventas on producto.id = ventas.producto_id
WHERE


--> 5
--> Score: 0.25
--> Feedback: Uso incorrecto de la función 'replace'
/*

Actualiza los productos Casio para que el nombre del
'Casio' instead of 'CASIO'.

*/
--> Answer:
UPDATE producto SET nombre = replace('CASIO', 'Casio');


