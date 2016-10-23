--http://www.sqlcourse.com/intro.html

--1. Selecting Data
--Display the first name and age for everyone that's in the table.
SELECT first, age FROM empinfo;

--Display the first name, last name, and city for everyone that's not from Payson.
SELECT first, last, city FROM empinfo WHERE city <> 'Payson';

--Display all columns for everyone that is over 40 years old.
SELECT * FROM empinfo WHERE age > 40;

--Display the first and last names for everyone whose last name ends in an "ay".
SELECT first, last FROM empinfo WHERE last LIKE '%ay';

--Display all columns for everyone whose first name equals "Mary".
SELECT * FROM empinfo WHERE first = 'Mary';

--Display all columns for everyone whose first name contains "Mary".
SELECT * FROM empinfo WHERE first LIKE '%Mary%';


--2. Creating Table
/*You have just started a new company. It is time to hire some employees. You will need to create a table that will contain the 
following information about your new employees: firstname, lastname, title, age, and salary. After you create the table, you should 
receive a small form on the screen with the appropriate column names. If you are missing any columns, you need to double check your 
SQL statement and recreate the table. Once it's created successfully, go to the "Insert" lesson.
*/
CREATE TABLE employee(firstname varchar(30) NOT NULL, lastname varchar(30) NOT NULL, title varchar(30) NOT NULL, age integer NOT NULL,
salary numeric NOT NULL);

--3. Inserting into a table
/*
It is time to insert data into your new employee table.

Your first three employees are the following:

Jonie Weber, Secretary, 28, 19500.00
Potsy Weber, Programmer, 32, 45300.00
Dirk Smith, Programmer II, 45, 75020.00

After they're inserted into the table, enter select statements to:

Select all columns for everyone in your employee table.
Select all columns for everyone with a salary over 30000.
Select first and last names for everyone that's under 30 years old.
Select first name, last name, and salary for anyone with "Programmer" in their title.
Select all columns for everyone whose last name contains "ebe".
Select the first name for everyone whose first name equals "Potsy".
Select all columns for everyone over 80 years old.
Select all columns for everyone whose last name ends in "ith".
*/
INSERT INTO employee(firstname, lastname, title, age, salary) values ('Jonie', 'Weber', 'Secretary', 28, 19500);
INSERT INTO employee(firstname, lastname, title, age, salary) values ('Potsy', 'Weber', 'Programmer', 32, 45300);
INSERT INTO employee(firstname, lastname, title, age, salary) values ('Drik', 'Smith', 'Programmer II', 45, 75020); 

SELECT * FROM employee;
SELECT * FROM employee WHERE salary > 30000;
SELECT firstname, lastname FROM employee WHERE age < 30;
SELECT firstname, lastname, salary FROM employee WHERE title LIKE '%Programmer%';
SELECT * FROM employee WHERE lastname LIKE '%ebe%';
SELECT firstname FROM employee WHERE firstname = 'Potsy';
SELECT * FROM employee WHERE age > 80;
SELECT * FROM employee WHERE lastname LIKE '%ith';

--4. Updating Records
/*
Jonie Weber just got married to Bob Williams. She has requested that her last name be updated to Weber-Williams.
Dirk Smith's birthday is today, add 1 to his age.
All secretaries are now called "Administrative Assistant". Update all titles accordingly.
Everyone that's making under 30000 are to receive a 3500 a year raise.
Everyone that's making over 33500 are to receive a 4500 a year raise.
All "Programmer II" titles are now promoted to "Programmer III".
All "Programmer" titles are now promoted to "Programmer II".
*/
UPDATE employee SET lastname = 'Weber-Williams' WHERE firstname = 'Jonie';
UPDATE employee SET  age = age + 1 WHERE firstname = 'Drik' AND lastname = 'Smith';
UPDATE employee SET  title = 'Administrative Assistant' WHERE title = 'Secretary';
UPDATE employee SET  salary = salary + 3500 WHERE salary < 30000;
UPDATE employee SET  salary = salary + 4500 WHERE salary > 33500;
UPDATE employee SET  title = 'Programmer III' WHERE title = 'Programmer II';
UPDATE employee SET  title = 'Programmer II' WHERE title = 'Programmer';

--5. Deleting Records
/*
Jonie Weber-Williams just quit, remove her record from the table.
It's time for budget cuts. Remove all employees who are making over 70000 dollars.
*/
DELETE FROM employee WHERE (firstname = 'Jonie') AND (lastname = 'Weber-Williams');

--6. Drop a Table
--Drop your employee table.
DROP TABLE employee;
DELETE FROM employee WHERE salary > 70000;