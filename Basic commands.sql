--Delete a table
drop table product_info;

--Create a table with some constraints
create table product_info(
product_No int NOT NULL PRIMARY KEY,
name text NOT NULL,
price real CHECK(price > 0),
discounted_price real CHECK(discounted_price > 0),
CHECK(price > discounted_price));

--Data that violates the constraints
insert into products(product_No, name, price, discounted_price) values (1, 'Soap', 1.29, 1.39);

--Insert some data into table
insert into product_info(product_No, name, price, discounted_price) values (1, 'Soap', 1.29, 1.09);
insert into product_info(product_No, name, price, discounted_price) values (2, 'Shampoo', 3.59, 3.29);
insert into product_info(product_No, name, price, discounted_price) values (3, 'Towel', 4.99, 4.39);
insert into product_info(product_No, name, price, discounted_price) values (4, 'Lotion', 6.29, 5.99);

--Take a look at the table
select * from product_info;

--Where clause
select * from product_info where price > 3.59;

--Check null entries in table
select * from product_info where price is null;

--Only want product names
select name from product_info where price is null;

--Logical operations
select * from product_info where price > 3.59 or discounted_price < 1.19;
select * from product_info where price between 1.09 and 2.09;
select * from product_info where price in('1.29', '4.99');
select * from product_info where name like '%am%';

--Display different column names
select name as Product_name from product_info;

--Count number of rows
select count(*) from product_info;

--Max, min, avg, and total price of products
select max(price) from product_info;
select min(price) from product_info;
select avg(price) from product_info;
select sum(price) from product_info;

--Primary and foreign key (Link two tables)
create table order_info(
order_No int PRIMARY KEY NOT NULL,
address text);

insert into order_info values(1, 'San Diego');

create table order_item(
product_No int NOT NULL REFERENCES product_info(product_No),
order_No int NOT NULL REFERENCES order_info(order_No),
quantity int NOT NULL);

--ERROR: Order_No 3 does not exist in order_info table
--insert into order_item values(1,3,3);

insert into order_item values(1,1,2);

--Alter table
alter table product_info ADD Made text;
select * from product_info;

alter table product_info DROP COLUMN Made;
select * from product_info;

--Add and delete primary key
alter table order_item ADD CONSTRAINT pri PRIMARY KEY(product_No);
alter table order_item DROP CONSTRAINT pri;

--Update and delete table elements
update product_info set price = 5.99 WHERE product_No = 3;
delete from product_info WHERE product_No = 3;

insert into product_info values(3,'Towel', 4.99, 4.39);

--Limit and offset
--Show first 2 rows
select * from product_info LIMIT 2;
--Exclude first 2 rows
select * from product_info OFFSET 2;

--Group and having
create table company(
id int PRIMARY KEY NOT NULL,
age int NOT NULL,
salary real NOT NULL);

insert into company values(1,25,3200);
insert into company values(2,21,2500);
insert into company values(3,36,6700);
insert into company values(4,40,9300);
insert into company values(5,25,3700);

select age,count(*) from company group by age;
select age,count(*) from company group by age having MAX(salary) > 2600;

--Sorting
select * from company order by salary ASC;
select * from company order by salary DESC;

select age from company cross join product_info;

--Remove duplicate
select distinct age from company;
