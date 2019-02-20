/*

Ejemplo sencillo, probablemente demasiado sencillo como examen.

-----------------------------------------------------------

Centro   : I.E.S. Acme Inc.
Clase    : DAW_1
Profesor : David
Alumno   :

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



--> Solution:
SELECT fecha
     , c.nombre
     , c.apellidos
     , p.nombre
     , s.cantidad
  FROM ventas s
  join cliente c on c.id = s.cliente_id
  join producto p  on p.id = s.producto_id
;

--> 2

/*

2. Añade un nuevo producto con estos datos:
 - Nombre  = Birthday Card Red Poppies
 - Precio = 2.49

*/



--> Solution:
INSERT INTO producto
  (nombre, precio)
VALUES
  ('Birthday Card Red Poppies', 2.49)
;

--> Test:
SELECT count(*)
  FROM producto
 WHERE nombre = 'Birthday Card Red Poppies'
   and precio = 2.49
;

--> 3



/*

3. Muestra el nombre del producto más caro.

*/

--> Solution:
   SELECT nombre
     FROM producto
 ORDER BY precio DESC
    LIMIT 1
;

--> 4



/*

4. ¿Que producto se ha vendido más veces?
Muestra las columnas:
 - Nombre del producto
 - Número de ventas
 - Cantidad vendida

*/

--> Solution:
  SELECT nombre
       , count(*)
       , sum(s.cantidad)
    FROM producto p
    join ventas s on s.producto_id = p.id
GROUP BY p.id
       , p.nombre
ORDER BY sum(s.cantidad) DESC
LIMIT 1
;

--> 5



/*

5. Actualiza los productos Casio para que el nombre del
producto contenga 'Casio' en lugar de 'CASIO'.

*/

--> Solution:
UPDATE producto
   SET nombre = replace(nombre, 'CASIO', 'Casio')
 WHERE nombre like '%CASIO%'
;

--> Test:
-- Importante: En SQlite 'like' no diferencia minúsculas de mayúsculas.
SELECT count(*) as NoCasio
     , (SELECT count(*) FROM producto
         WHERE nombre like '%casio%'
           and nombre = replace(nombre, 'CASIO', 'Casio')) as GoodCasio
  FROM producto
 WHERE lower(nombre) not like '%casio%'
;

