/*

Just an example... this would be a very easy exam.

-----------------------------------------------------------

School : Acme Inc
Class  : DAW_1
Teacher: Jonh Doe
Student:

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



--> Solution:
SELECT "date"
     , c.firstname
     , c.lastname
     , p.name
     , s.quantity
  FROM sales s
  join customer c on c.id = s.customer_id
  join product p  on p.id = s.product_id
;

--> 2

/*

2. Insert a new product using this data:
 - Name  = Birthday Card Red Poppies
 - Price = 2.49

*/



--> Solution:
INSERT INTO product
  (name, price)
VALUES
  ('Birthday Card Red Poppies', 2.49)
;

--> Test:
SELECT count(*)
  FROM product
 WHERE name = 'Birthday Card Red Poppies'
   and price = 2.49
;

--> 3



/*

Select the product name of the most expensive product.

*/

--> Solution:
   SELECT name
     FROM product
 ORDER BY price DESC
    LIMIT 1
;

--> 4



/*

Which product has been sold more times?
Display:
 - Product name
 - Number of sales that include that product
 - Number or products sold

*/

--> Solution:
  SELECT name
       , count(*)
       , sum(s.quantity)
    FROM product p
    join sales s on s.product_id = p.id
GROUP BY p.id
       , p.name
ORDER BY sum(s.quantity) DESC
LIMIT 1
;

--> 5



/*

Update Casio products so product name includes
'Casio' instead of 'CASIO'.

*/

--> Solution:
UPDATE product
   SET name = replace(name, 'CASIO', 'Casio')
 WHERE name like '%CASIO%'
;

--> Test:
-- Notice like is case insensitive (by default) in SQlite
SELECT count(*) as NoCasio
     , (SELECT count(*) FROM product
         WHERE name like '%casio%'
           and name = replace(name, 'CASIO', 'Casio')) as GoodCasio
  FROM product
 WHERE lower(name) not like '%casio%'
;

