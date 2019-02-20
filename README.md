# sql-gh

Tool to facilitate teachers the process of grading database exams.

## Description
The main goals of this program are:
* Reduce the time of marking exams.
* Produce more precise and objetive marks.

In order to do that, the software:
* Provides a [template](doc/templates/exam_solved.sql) you have to use to prepare exams.
* Compiles all your students exams into a single file where you have to mark. This file:
  * Contains all the students' answers reordered to facilitate the marking process.
  * Contains execution information of all the students' answers> Does the code execute? Does it produce the same result as the right solution?
* Will extract scores from the compiled file and transfer them to the students' exams.

The aim is to **help** you, not to do the work for you. That said, there is a command to automatically mark exams as well.

## Usage example
An example will illustrate what this program really does.

### Basic use
You can use the **help** command in the application to get a list of available commands. You can as well do **help command** to get help for a specific command.

Use **quit** for exiting the application.

Any command can be autocompleted using the **tab** key.

### Example
*To keep this example short everything will be heavily simplified.*

If you want to test your students' knowledge you will need an **exam.sql** with some questions, and a **schema.sql** that creates some database to perform the exam on it.

[**schema.sql**](doc/examples/sqlite/01_schema.sql)
```
-- Create tables
CREATE TABLE customer (
  id        integer primary key,
  firstname text,
  lastname  text
);

CREATE TABLE product (
  id            integer primary key,
  name          text,
  price         real
);

-- Add data
INSERT INTO customer
  (firstname, lastname)
VALUES
  ('Barry', 'Shmelly'),
  ('Bjorn', 'Free'),
  ('Casey', 'Deeya'),
  ('Doug', 'Graves'),
  ('Ellie', 'Noise'),
  ('Ken', 'Hardly')
;

INSERT INTO product
  (name, price)
VALUES
  ('Papermate Blue Pen', 1.59),
  ('Papermate Black Pen', 1.59),
  ('Writing paper 100 sheets', 3.79),
  ('Moderno Notebook', 4.99),
  ('Moderno Bullet Journal', 7.99),
  ('Post-it notes (pack of 300)', 2.99),
  ('Post-it 10 slim sticky notes', 4.99),
  ('CASIO FX-991EX Scientific Calculator', 27.99),
  ('CASIO FX-CG50 Graphic Calculator', 119.99)
;

```
sql-gh requires that you provide questions and answers, so you would have an [**exam_solved.sql**](02_exam_solved.sql) file:

```
/*
  Exam header. School and class info, exam instructions and whatever you want to include.
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

--> Test:

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

-- ...
```

This file needs to be created using the provided [template](doc/templates/exam_solved.sql).

Once you have [**schema.sql**](doc/examples/sqlite/01_schema.sql) and [**exam_solved.sql**](doc/examples/sqlite/02_exam_solved.sql) files, you can add those to sql-gh:

```
sql-gh> add exam_name default path/to/schema.sql path/to/exam_solved.sql
Template exam generated in ~/.sql-gh/projects/exam_name/exam_template.sql
Please provide this template to students.
Once they have finished, copy all the <student_name.sql> files to ~/.sql-gh/projects/exam_name/01_students_exams and execute `hint exam_name` command to get partial grades
```

This produces the [**exam_template.sql**](doc/examples/sqlite/03_exam_template.sql) file which contains only exam questions.

You will give **schema.sql** and **example_template.sql** to your students so they can take the test. After they have done it, you'll have one **student_name.sql** for each student you have.

[**alice.sql**](doc/examples/sqlite/04_student_exam_alice.sql)

```
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
```

[**bob.sql**](doc/examples/sqlite/04_student_exam_bob.sql)
```
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
FROM sales s join product p on s.product_id = p.id
join customer c on c.id = sales.customer_id
ORDER BY "date";

--> 2
/*

2. Insert a new product using this data:
 - Name  = Birthday Card Red Poppies
 - Price = 2.49

*/
--> Answer:
INSERT INTO product (name, price)
VALUES ('Birthday Card Red Popies', 2.49);
```

You need to copy student files to *~/.sql-gh/projects/exam_name/01_students_exams*, then you run:
```
sql-gh> hint exam_name
Hints generated correctly in file
~/.sql-gh/projects/exam_name/02_exercises_with_marks/exercises_with_hints.sql.
Edit this file and assign marks to all exercises.
Once you are done execute `mark exam_name`
```
This will give you the [**exercises_with_hints.sql**](doc/examples/sqlite/05_exercises_with_hints.sql) file:
```
--> Exercise   : 1
--> Student    : bob
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
--> Student    : alice
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
```

*sql-gh* executes each student answer and presents the execution information in this file. You need to edit this file and replace <score> and <feedback> marks by the appropriate score/feedback.
 
Once you are done:
```
sql-gh> mark exam_name
```
Will extract the score and feedback information and put it back in the original students' exam files.

Instead of **hint** and **mark**, you can use **magic_autoscore**. That will assign scores automatically.

## Supported RDBMS
* SQLite
* MySQL
* PostgreSQL

## Prerequisites

You need Python 3 and a few modules.

### Linux:

Simply:
```
$ sudo apt install python3-mysql.connector python3-psycopg2
```

### Windows:

Fist, you need to install python3: https://www.python.org/downloads/windows/

Then:

```
> python -m pip install --upgrade pip
> python -m pip install pyreadline
> python -m pip install mysql.connector
> python -m pip install mysql-connector-python
> python -m pip install psycopg2
```

## Installing

sql-gh doesn't require an installation. Simply download sql-gh and execute it:

```
$ git clone https://github.com/DavidEGx/sql-gh.git
$ cd sql-gh
$ python3 ./sql-gh.py
```

or get dist file:

```
$ wget https://github.com/DavidEGx/sql-gh/dist/sqlgh-current.tar.gz
$ tar xzvf sqlgh-current.tar.gz
$ cd sqlgh
$ python3 ./sql-gh.py

```

## Authors

* **David Escribano García**

## License

This project is licensed under the European Public License (EUPL) - see the [LICENSE](LICENSE) file for details

