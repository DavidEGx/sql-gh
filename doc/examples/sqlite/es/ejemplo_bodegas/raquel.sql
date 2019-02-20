/*
Cabecera con datos del centro, profesor, curso, clase, instrucciones para realizar la prueba, etc.
*/

--> 1
/*
1. Nombre de los vinos de las bodegas Artuke y Bretón en orden alfabético de bodega y vino. Campos a mostrar: nombre de la bodega, nombre del vino, año y tipo.
*/
--> Answer: 
select b.nombre, denominacion, año, tipo
from bodega b join vino v on v.idbodega = b.idbodega
where nombre = 'Bodegas Artuke' or nombre = 'Bodegas Bretón'
;

--> 2
/*
2. Eliminar las bodegas que no tienen vinos
*/
--> Answer: 
DELETE FROM bodega;
