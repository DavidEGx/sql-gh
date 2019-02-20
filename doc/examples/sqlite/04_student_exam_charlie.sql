/*

-----------------------------------------------------------

School : Acme Inc
Class  : DAW_1
Teacher: Jonh Doe
Student: Charlie

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
SELECT * FROM product left join sales on product.id = sales.product_id
ORDER BY sales.date DESC;

--> 2
/*

2. Insert a new product using this data:
 - Name  = Birthday Card Red Poppies
 - Price = 2.49

*/
--> Answer:
INSERT INTO product (name, price) VALUES ('Birthday Card Red Poppies', 2.49);

--> 3
/*

Select the product name of the most expensive product.

*/
--> Answer:
SELECT max(price) FROM product;

--> 4
/*

Which product has been sold more times?
Display:
 - Product name
 - Number of sales that include that product
 - Number or products sold

*/
--> Answer:
SELECT * FROM product join sales on product.id = sales.product_id
WHERE




--> 5
/*

Update Casio products so product name includes
'Casio' instead of 'CASIO'.

*/
--> Answer:
UPDATE product SET name = replace('CASIO', 'Casio');

