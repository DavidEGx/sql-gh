--> Exercise   : 1
--> Student    : 04_examen_carlos.sql
--> sql-gh info:
-->     Code executes  : True
-->     Execution error: 
-->     Result matches solution: False
-->     Result matches solution ignoring order: False
-->     Result contains same number of rows as solution: False
-->     Result contains same number of cols as solution: False
--> Score      : 0.75
--> Feedback   : Solo debes mostrar las columnas pedidas 
--> Answer     :
SELECT * FROM producto left join ventas on producto.id = ventas.producto_id
ORDER BY ventas.date DESC;


--> Exercise   : 1
--> Student    : 04_examen_berto.sql
--> sql-gh info:
-->     Code executes  : False
-->     Execution error: no such column: ventas.cliente_id
-->     Result matches solution: False
-->     Result matches solution ignoring order: False
-->     Result contains same number of rows as solution: False
-->     Result contains same number of cols as solution: False
--> Score      : 0.5
--> Feedback   : No puedes usar 'ventas' como nombre porque has usado una alias. Debes usar orden DESCendente
--> Answer     :
SELECT fecha, nombre, apellidos, nombre, cantidad
FROM ventas s join producto p on s.producto_id = p.id
join cliente c on c.id = ventas.cliente_id
ORDER BY fecha;


--> Exercise   : 1
--> Student    : 04_examen_alicia.sql
--> sql-gh info:
-->     Code executes  : True
-->     Execution error: 
-->     Result matches solution: False
-->     Result matches solution ignoring order: True
-->     Result contains same number of rows as solution: True
-->     Result contains same number of cols as solution: True
--> Score      : 1
--> Feedback   : Bien.
--> Answer     :
SELECT fecha, nombre, apellidos, nombre, cantidad
FROM ventas, producto, cliente
WHERE ventas.producto_id = producto.id and cliente.id = ventas.cliente_id
ORDER BY fecha DESC
;


--> Exercise   : 2
--> Student    : 04_examen_carlos.sql
--> sql-gh info:
-->     Code executes  : True
-->     Execution error: 
-->     Result matches solution: True
-->     Result matches solution ignoring order: True
-->     Result contains same number of rows as solution: True
-->     Result contains same number of cols as solution: True
--> Score      : 1
--> Feedback   : Bien
--> Answer     :
INSERT INTO producto (nombre, precio) VALUES ('Birthday Card Red Poppies', 2.49);


--> Exercise   : 2
--> Student    : 04_examen_berto.sql
--> sql-gh info:
-->     Code executes  : True
-->     Execution error: 
-->     Result matches solution: False
-->     Result matches solution ignoring order: False
-->     Result contains same number of rows as solution: True
-->     Result contains same number of cols as solution: True
--> Score      : 0.9
--> Feedback   : 'Poppies', no 'Popies'
--> Answer     :
INSERT INTO producto (nombre, precio)
VALUES ('Birthday Card Red Popies', 2.49);


--> Exercise   : 2
--> Student    : 04_examen_alicia.sql
--> sql-gh info:
-->     Code executes  : True
-->     Execution error: 
-->     Result matches solution: True
-->     Result matches solution ignoring order: True
-->     Result contains same number of rows as solution: True
-->     Result contains same number of cols as solution: True
--> Score      : 1
--> Feedback   : Bien
--> Answer     :
INSERT INTO producto VALUES (null, 'Birthday Card Red Poppies', 2.49);


--> Exercise   : 3
--> Student    : 04_examen_carlos.sql
--> sql-gh info:
-->     Code executes  : True
-->     Execution error: 
-->     Result matches solution: False
-->     Result matches solution ignoring order: False
-->     Result contains same number of rows as solution: True
-->     Result contains same number of cols as solution: True
--> Score      : 0
--> Feedback   : Tenías que mostrar el nombre del producto, no el precio
--> Answer     :
SELECT max(precio) FROM producto;


--> Exercise   : 3
--> Student    : 04_examen_berto.sql
--> sql-gh info:
-->     Code executes  : True
-->     Execution error: 
-->     Result matches solution: True
-->     Result matches solution ignoring order: True
-->     Result contains same number of rows as solution: True
-->     Result contains same number of cols as solution: True
--> Score      : 1
--> Feedback   : Bien
--> Answer     :
SELECT nombre
FROM producto
ORDER BY precio DESC
LIMIT 1;


--> Exercise   : 3
--> Student    : 04_examen_alicia.sql
--> sql-gh info:
-->     Code executes  : False
-->     Execution error: near "ALL": syntax error
-->     Result matches solution: False
-->     Result matches solution ignoring order: False
-->     Result contains same number of rows as solution: False
-->     Result contains same number of cols as solution: False
--> Score      : 0.5
--> Feedback   : ALL se puede usar en otros RDBMS, NO en SQLite
--> Answer     :
SELECT nombre FROM producto WHERE precio >= ALL (SELECT max(precio) FROM producto);


--> Exercise   : 4
--> Student    : 04_examen_carlos.sql
--> sql-gh info:
-->     Code executes  : False
-->     Execution error: incomplete input
-->     Result matches solution: False
-->     Result matches solution ignoring order: False
-->     Result contains same number of rows as solution: False
-->     Result contains same number of cols as solution: False
--> Score      : 0
--> Feedback   : 
--> Answer     :
SELECT * FROM producto join ventas on producto.id = ventas.producto_id
WHERE


--> Exercise   : 4
--> Student    : 04_examen_berto.sql
--> sql-gh info:
-->     Code executes  : True
-->     Execution error:
-->     Result matches solution: False
-->     Result matches solution ignoring order: False
-->     Result contains same number of rows as solution: True
-->     Result contains same number of cols as solution: True
--> Score      : 0.25
--> Feedback   : sum(s.cantidad) en lugar de count(s.cantidad)
--> Answer     :
SELECT p.nombre, count(s.id), count(s.cantidad)
FROM ventas s join producto p on p.id = s.producto_id
GROUP BY p.nombre
ORDER BY count(s.cantidad) DESC
LIMIT 1;


--> Exercise   : 4
--> Student    : 04_examen_alicia.sql
--> sql-gh info:
-->     Code executes  : True
-->     Execution error: 
-->     Result matches solution: True
-->     Result matches solution ignoring order: True
-->     Result contains same number of rows as solution: True
-->     Result contains same number of cols as solution: True
--> Score      : 1
--> Feedback   : Bien
--> Answer     :
SELECT producto.nombre, count(ventas.id), sum(ventas.cantidad)
FROM ventas, producto
WHERE ventas.producto_id = producto.id
GROUP BY producto.nombre
ORDER BY sum(ventas.cantidad) DESC
LIMIT 1;


--> Exercise   : 5
--> Student    : 04_examen_carlos.sql
--> sql-gh info:
-->     Code executes  : False
-->     Execution error: wrong number of arguments to function replace()
-->     Result matches solution: False
-->     Result matches solution ignoring order: False
-->     Result contains same number of rows as solution: False
-->     Result contains same number of cols as solution: False
--> Score      : 0.25
--> Feedback   : Uso incorrecto de la función 'replace'
--> Answer     :
UPDATE producto SET nombre = replace('CASIO', 'Casio');


--> Exercise   : 5
--> Student    : 04_examen_berto.sql
--> sql-gh info:
-->     Code executes  : True
-->     Execution error: 
-->     Result matches solution: True
-->     Result matches solution ignoring order: True
-->     Result contains same number of rows as solution: True
-->     Result contains same number of cols as solution: True
--> Score      : 1
--> Feedback   : Bien
--> Answer     :
UPDATE producto SET nombre = replace(nombre, 'CASIO', 'Casio') WHERE nombre like '%casio%';


--> Exercise   : 5
--> Student    : 04_examen_alicia.sql
--> sql-gh info:
-->     Code executes  : True
-->     Execution error: 
-->     Result matches solution: True
-->     Result matches solution ignoring order: True
-->     Result contains same number of rows as solution: True
-->     Result contains same number of cols as solution: True
--> Score      : 1
--> Feedback   : Bien
--> Answer     :
UPDATE producto
SET nombre = replace(nombre, 'CASIO', 'Casio');


