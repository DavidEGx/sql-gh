/*

-----------------------------------------------------------

School : Acme Inc
Class  : DAW_1
Teacher: Jonh Doe
Student: Bob

-----------------------------------------------------------

Exam instructions:

* Create a new database using the provided file schema.sql.
* Copy this file and name it <your_name.sql>.
* Open the file <your_name.sql> and answer to each
  question in the gaps provided.
* Save it frequently to avoid data loss.
* When you have finished provide the file <your_name.sql>
  to the teacher.

-----------------------------------------------------------

*/


--------------------------------------------------------------------------------
--> TOTAL SCORE: 3.65
--------------------------------------------------------------------------------

--> 1
--> Score: 0.5
--> Feedback: You cannot use 'sales' as you aliased the table. You needed to use DESCending order.
/*

1. Get a sales list ordered in such a way the most
recent sale is shown first.
Include columns:
 - date
 - customer first name
 - customer last name
 - product name
 - quantity

*/
--> Answer:
SELECT "date", firstname, lastname, name, quantity
FROM sales s join product p on s.product_id = p.id
join customer c on c.id = sales.customer_id
ORDER BY "date";


--> 2
--> Score: 0.9
--> Feedback: 'Poppies' not 'Popies'
/*

2. Insert a new product using this data:
 - Name  = Birthday Card Red Poppies
 - Price = 2.49

*/
--> Answer:
INSERT INTO product (name, price)
VALUES ('Birthday Card Red Popies', 2.49);


--> 3
--> Score: 1.0
--> Feedback: Well done
/*

Select the product name of the most expensive product.

*/
--> Answer:
SELECT name
FROM product
ORDER BY price DESC
LIMIT 1;


--> 4
--> Score: 0.25
--> Feedback: You needed to use sum(s.quantity) instead of count(s.quantity)
/*

Which product has been sold more times?
Display:
 - Product name
 - Number of sales that include that product
 - Number or products sold

*/
--> Answer:
SELECT p.name, count(s.id), count(s.quantity)
FROM sales s join product p on p.id = s.product_id
GROUP BY p.name
ORDER BY count(s.quantity) DESC
LIMIT 1;


--> 5
--> Score: 1.0
--> Feedback: Well done
/*

Update Casio products so product name includes
'Casio' instead of 'CASIO'.

*/
--> Answer:
UPDATE product SET name = replace(name, 'CASIO', 'Casio') WHERE name like '%casio%';


