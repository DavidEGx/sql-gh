--> Exercise   : 1
--> Student    : 04_student_exam_charlie
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
SELECT * FROM product left join sales on product.id = sales.product_id
ORDER BY sales.date DESC;


--> Exercise   : 1
--> Student    : 04_student_exam_bob
--> sql-gh info:
-->     Code executes  : False
-->     Execution error: no such column: sales.customer_id
-->     Result matches solution: False
-->     Result matches solution ignoring order: False
-->     Result contains same number of rows as solution: False
-->     Result contains same number of cols as solution: False
--> Score      : <score>
--> Feedback   : <feedback>
--> Answer     :
SELECT "date", firstname, lastname, name, quantity
FROM sales s join product p on s.product_id = p.id
join customer c on c.id = sales.customer_id
ORDER BY "date";


--> Exercise   : 1
--> Student    : 04_student_exam_alice
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
SELECT "date", firstname, lastname, name, quantity
FROM sales, product, customer
WHERE sales.product_id = product.id and customer.id = sales.customer_id
ORDER BY "date" DESC
;


--> Exercise   : 2
--> Student    : 04_student_exam_charlie
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
INSERT INTO product (name, price) VALUES ('Birthday Card Red Poppies', 2.49);


--> Exercise   : 2
--> Student    : 04_student_exam_bob
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
INSERT INTO product (name, price)
VALUES ('Birthday Card Red Popies', 2.49);


--> Exercise   : 2
--> Student    : 04_student_exam_alice
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
INSERT INTO product VALUES (null, 'Birthday Card Red Poppies', 2.49);


--> Exercise   : 3
--> Student    : 04_student_exam_charlie
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
SELECT max(price) FROM product;


--> Exercise   : 3
--> Student    : 04_student_exam_bob
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
SELECT name
FROM product
ORDER BY price DESC
LIMIT 1;


--> Exercise   : 3
--> Student    : 04_student_exam_alice
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
SELECT name FROM product WHERE price >= ALL (SELECT max(price) FROM product);


--> Exercise   : 4
--> Student    : 04_student_exam_charlie
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
SELECT * FROM product join sales on product.id = sales.product_id
WHERE


--> Exercise   : 4
--> Student    : 04_student_exam_bob
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
SELECT p.name, count(s.id), count(s.quantity)
FROM sales s join product p on p.id = s.product_id
GROUP BY p.name
ORDER BY count(s.quantity) DESC
LIMIT 1;


--> Exercise   : 4
--> Student    : 04_student_exam_alice
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
SELECT product.name, count(sales.id), sum(sales.quantity)
FROM sales, product
WHERE sales.product_id = product.id
GROUP BY product.name
ORDER BY sum(sales.quantity) DESC
LIMIT 1;


--> Exercise   : 5
--> Student    : 04_student_exam_charlie
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
UPDATE product SET name = replace('CASIO', 'Casio');


--> Exercise   : 5
--> Student    : 04_student_exam_bob
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
UPDATE product SET name = replace(name, 'CASIO', 'Casio') WHERE name like '%casio%';


--> Exercise   : 5
--> Student    : 04_student_exam_alice
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
UPDATE product
SET name = replace(name, 'CASIO', 'Casio');


