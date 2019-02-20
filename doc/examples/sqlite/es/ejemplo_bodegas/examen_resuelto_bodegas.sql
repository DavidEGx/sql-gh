/*
Cabecera con datos del centro, profesor, curso, clase, instrucciones para realizar la prueba, etc.
*/

--> 1
/*
1. Nombre de los vinos de las bodegas Artuke y Bretón en orden alfabético de bodega y vino. Campos a mostrar: nombre de la bodega, nombre del vino, año y tipo.
*/

--> Solution:
  SELECT b.nombre, denominacion, año, tipo
    FROM bodega b
    join vino v on v.idbodega = b.idbodega
   WHERE nombre IN ('Bodegas Artuke', 'Bodegas Bretón')
ORDER BY nombre, denominacion
;
--> Test:

--> 2
/*
2. Eliminar las bodegas que no tienen vinos
*/

--> Solution:
DELETE FROM bodega WHERE idbodega not in (SELECT idbodega FROM vino);

--> Test:
SELECT * FROM bodega;
