/*

-----------------------------------------------------------

School : Acme Inc
Class  : DAW_1
Teacher: Jonh Doe
Student: Alice

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

--> 1
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
FROM sales, product, customer
WHERE sales.product_id = product.id and customer.id = sales.customer_id
ORDER BY "date" DESC
;

--> 2
/*

2. Insert a new product using this data:
 - Name  = Birthday Card Red Poppies
 - Price = 2.49

*/
--> Answer:
INSERT INTO product VALUES (null, 'Birthday Card Red Poppies', 2.49);

--> 3
/*

Select the product name of the most expensive product.

*/
--> Answer:
SELECT name FROM product WHERE price >= ALL (SELECT max(price) FROM product);

--> 4
/*

Which product has been sold more times?
Display:
 - Product name
 - Number of sales that include that product
 - Number or products sold

*/
--> Answer:
SELECT product.name, count(sales.id), sum(sales.quantity)
FROM sales, product
WHERE sales.product_id = product.id
GROUP BY product.name
ORDER BY sum(sales.quantity) DESC
LIMIT 1;




--> 5
/*

Update Casio products so product name includes
'Casio' instead of 'CASIO'.

*/
--> Answer:
UPDATE product
SET name = replace(name, 'CASIO', 'Casio');
