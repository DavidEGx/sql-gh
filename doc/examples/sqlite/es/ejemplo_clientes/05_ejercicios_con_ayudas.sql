--> Exercise   : 1
--> Student    : 04_examen_carlos.sql
--> sql-gh info:
-->     Code executes  : True
-->     Execution error: 
-->     Result matches solution: False
-->     Result matches solution ignoring order: False
-->     Result contains same number of rows as solution: False
-->     Result contains same number of cols as solution: False
--> Score      : <score>
--> Feedback   : <feedback>
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
--> Score      : <score>
--> Feedback   : <feedback>
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
--> Score      : <score>
--> Feedback   : <feedback>
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
--> Score      : <score>
--> Feedback   : <feedback>
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
--> Score      : <score>
--> Feedback   : <feedback>
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
--> Score      : <score>
--> Feedback   : <feedback>
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
--> Score      : <score>
--> Feedback   : <feedback>
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
--> Score      : <score>
--> Feedback   : <feedback>
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
--> Score      : <score>
--> Feedback   : <feedback>
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
--> Score      : <score>
--> Feedback   : <feedback>
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
--> Score      : <score>
--> Feedback   : <feedback>
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
-->     Result matches solution: False
-->     Result matches solution ignoring order: False
-->     Result contains same number of rows as solution: True
-->     Result contains same number of cols as solution: True
--> Score      : <score>
--> Feedback   : <feedback>
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
--> Score      : <score>
--> Feedback   : <feedback>
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
--> Score      : <score>
--> Feedback   : <feedback>
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
--> Score      : <score>
--> Feedback   : <feedback>
--> Answer     :
UPDATE producto
SET nombre = replace(nombre, 'CASIO', 'Casio');


