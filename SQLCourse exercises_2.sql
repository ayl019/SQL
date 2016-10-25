--http://www.sqlcourse2.com/intro2.html

/*
   Tables used
   http://www.sqlcourse2.com/items_ordered.html
   http://www.sqlcourse2.com/customers.html
*/

--1. Select Statement
/* 
   From the items_ordered table, select a list of all items purchased for customerid 10449. Display the customerid, item, and price for this customer.
   Select all columns from the items_ordered table for whoever purchased a Tent.
   Select the customerid, order_date, and item values from the items_ordered table for any items in the item column that start with the letter "S".
   Select the distinct items in the items_ordered table. In other words, display a listing of each of the unique items from the items_ordered table.
*/

SELECT customerid, item, price FROM items_ordered WHERE customerid = 10449;
SELECT * FROM items_ordered WHERE item = 'Tent';
SELECT customerid, order_date, item FROM items_ordered WHERE item LIKE 'S%';
SELECT DISTINCT item FROM items_ordered;

--2. Aggregate Functions
/*
   Select the maximum price of any item ordered in the items_ordered table. Hint: Select the maximum price only.
   Select the average price of all of the items ordered that were purchased in the month of Dec.
   What are the total number of rows in the items_ordered table?
   For all of the tents that were ordered in the items_ordered table, what is the price of the lowest tent? Hint: Your query should return the price only.
*/

SELECT max(price) FROM items_ordered;
SELECT avg(price) FROM items_ordered WHERE order_date LIKE '%Dec%';
SELECT count(*) FROM items_ordered;
SELECT min(price) FROM items_ordered WHERE item = 'Tent';

--3. Group by Clause
/*
   How many people are in each unique state in the customers table? Select the state and display the number of people in each. Hint: count is used to count rows in a column, sum works on numeric data only.
   From the items_ordered table, select the item, maximum price, and minimum price for each specific item in the table. Hint: The items will need to be broken up into separate groups.
   How many orders did each customer make? Use the items_ordered table. Select the customerid, number of orders they made, and the sum of their orders. Click the Group By answers link below if you have any problems.
*/

SELECT state, count(state) FROM customers GROUP BY state;
SELECT item, max(price), min(price) FROM items_ordered GROUP BY item;
SELECT customerid, count(customerid), sum(price) FROM items_ordered GROUP BY customerid;

--4. Having clause
/*
   How many people are in each unique state in the customers table that have more than one person in the state? Select the state and display the number of how many people are in each if it's greater than 1.
   From the items_ordered table, select the item, maximum price, and minimum price for each specific item in the table. Only display the results if the maximum price for one of the items is greater than 190.00.
   How many orders did each customer make? Use the items_ordered table. Select the customerid, number of orders they made, and the sum of their orders if they purchased more than 1 item.
*/

SELECT state, count(state) FROM customers GROUP BY state HAVING count(state) > 1;
SELECT item, max(price), min(price) FROM items_ordered GROUP BY item HAVING max(price) > 190.00;
SELECT customerid, count(customerid), sum(price) FROM customers GROUP BY customerid HAVING count(customerid) > 1;

--5. Order by Clause
/*
   Select the lastname, firstname, and city for all customers in the customers table. Display the results in Ascending Order based on the lastname.
   Same thing as exercise #1, but display the results in Descending order.
   Select the item and price for all of the items in the items_ordered table that the price is greater than 10.00. Display the results in Ascending order based on the price.
*/

SELECT lastname, firstname, city FROM customers ORDER BY lastname;
SELECT lastname, firstname, city FROM customers ORDER BY lastname DESC;
SELECT item, price FROM items_ordered WHERE price > 10.00 ORDER BY price ASC;

--6. Combining Conditions & Boolean Operators
/*
   Select the customerid, order_date, and item from the items_ordered table for all items unless they are 'Snow Shoes' or if they are 'Ear Muffs'. Display the rows as long as they are not either of these two items.
   Select the item and price of all items that start with the letters 'S', 'P', or 'F'.
*/

SELECT customerid, order_date, item FROM items_ordered WHERE (item <> 'Snow Shoes') AND (item <> 'Ear Muffs');
SELECT item, price FROM items_ordered WHERE (item LIKE 'S%') OR (item LIKE 'P%') OR (item LIKE 'F%');

--7. IN and BETWEEN
/*
   Select the date, item, and price from the items_ordered table for all of the rows that have a price value ranging from 10.00 to 80.00.
   Select the firstname, city, and state from the customers table for all of the rows where the state value is either: Arizona, Washington, Oklahoma, Colorado, or Hawaii.
*/

SELECT date, item, price FROM items_ordered WHERE price BETWEEN 10 AND 80;
SELECT firstname, city, state FROM customers WHERE state IN ('Arizona', 'Washington', 'Oklahoma', 'Colorado', 'Hawaii');

--8. Table Joins
/*
   Write a query using a join to determine which items were ordered by each of the customers in the customers table. Select the customerid, firstname, lastname, order_date, item, and price for everything each customer purchased in the items_ordered table.
   Repeat exercise #1, however display the results sorted by state in descending order.
*/

SELECT customers.customerid, customers.firstname, customers.lastname, items_ordered.order_date, items_ordered.item, items_ordered.price FROM customers, items_ordered
WHERE customer.customerid = items_ordered.customerid;

SELECT customer.state, customer.customerid, customers.firstname, customers.lastname, items_ordered.order_date, items_ordered.item, items_ordered.price FROM customers, item_ordered
WHERE customer.customerid = item_ordered.customerid ORDER BY customers.state DESC;