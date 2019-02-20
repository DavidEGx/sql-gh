/*

-----------------------------------------------------------

Centro   : I.E.S. Acme Inc.
Clase    : DAW_1
Profesor : David
Alumno   : Berto

-----------------------------------------------------------

Instrucciones:

* Crea una nueva base de datos usando el fichero esquema.sql
  que se te ha entregado.
* Copia este fichero usando el nombre <tu_nombre.sql>.
* Abre el fichero <tu_nombre.sql> y response a cada pregunta
  en los espacios correspondientes.
* Guarda el fichero con frecuencia para evitar cualquier
  pérdida de datos.
* Cuando hayas finalizado debes entregar el fichero
  <tu_nombre.sql> con todas tus respuestas.
* Lee cuidadosamente cada pregunta.

-----------------------------------------------------------

*/

--> 1
/*

1. Obtén una lista de ventas de forma que la más reciente
aparece primero.
Incluye las columnas:
 - fecha de la venta
 - nombre del cliente
 - apellidos del cliente
 - nombre del producto
 - cantidad

*/
--> Answer:
SELECT fecha, nombre, apellidos, nombre, cantidad
FROM ventas s join producto p on s.producto_id = p.id
join cliente c on c.id = ventas.cliente_id
ORDER BY fecha;

--> 2
/*

2. Añade un nuevo producto con estos datos:
 - Nombre  = Birthday Card Red Poppies
 - Precio = 2.49

*/
--> Answer:
INSERT INTO producto (nombre, precio)
VALUES ('Birthday Card Red Popies', 2.49);

--> 3
/*

Muestra el nombre del producto más caro.

*/
--> Answer:
SELECT nombre
FROM producto
ORDER BY precio DESC
LIMIT 1;

--> 4
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
/*

Actualiza los productos Casio para que el nombre del
'Casio' instead of 'CASIO'.

*/
--> Answer:
UPDATE producto SET nombre = replace(nombre, 'CASIO', 'Casio') WHERE nombre like '%casio%';

