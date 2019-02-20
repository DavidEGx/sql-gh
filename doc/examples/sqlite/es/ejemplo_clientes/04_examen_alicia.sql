/*

-----------------------------------------------------------

Centro   : I.E.S. Acme Inc.
Clase    : DAW_1
Profesor : David
Alumno   : Alicia

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
SELECT fecha, cliente.nombre, apellidos, producto.nombre, cantidad
FROM ventas, producto, cliente
WHERE ventas.producto_id = producto.id and cliente.id = ventas.cliente_id
ORDER BY fecha DESC
;

--> 2
/*

2. Añade un nuevo producto con estos datos:
 - Nombre  = Birthday Card Red Poppies
 - Precio = 2.49

*/
--> Answer:
INSERT INTO producto VALUES (null, 'Birthday Card Red Poppies', 2.49);

--> 3
/*

Muestra el nombre del producto más caro.

*/
--> Answer:
SELECT nombre FROM producto WHERE precio >= ALL (SELECT max(precio) FROM producto);

--> 4
/*

¿Que producto se ha vendido más veces?
Muestra las columnas:
 - Nombre del producto
 - Número de ventas
 - Cantidad vendida

*/
--> Answer:
SELECT producto.nombre, count(ventas.id), sum(ventas.cantidad)
FROM ventas, producto
WHERE ventas.producto_id = producto.id
GROUP BY producto.nombre
ORDER BY sum(ventas.cantidad) DESC
LIMIT 1;




--> 5
/*

Actualiza los productos Casio para que el nombre del
'Casio' instead of 'CASIO'.

*/
--> Answer:
UPDATE producto
SET nombre = replace(nombre, 'CASIO', 'Casio');
