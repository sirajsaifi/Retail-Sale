create database sales_retail_p1;

use sales_retail_p1;

create table retail_sales (
	transactions_id int,
    sale_date date,
    sale_time time,
    customer_id int,
    gender varchar(15),
    age int default null,
    category varchar(15),
    quantity int,
    price_per_unit float,
    cogs float,
    total_sale float,
    primary key(transactions_id)
);

select * 
from 
retail_sales;

show variables like "local_infile";

set global local_infile=0;

alter table retail_sales modify age int default null;

LOAD DATA INFILE 'RetailSales.csv'
INTO TABLE retail_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 lines
(transactions_id, sale_date, sale_time, customer_id, gender, @age, category, @quantity, @price_per_unit, @cogs, @total_sale)
set age = nullif(@age, ''),
quantity = nullif(@quantity, ''),
price_per_unit = nullif(@price_per_unit, ''),
cogs = nullif(@cogs, ''),
total_sale = nullif(@total_sale, '');

select * 
from
	retail_sales 
limit 10;


-- data cleaning
select * 
from 
	retail_sales 
where 
	quantity is null;

select * 
from 
	retail_sales 
where
	quantity is null or
	age is null;

select * 
from 
	retail_sales 
where 
	quantity is null 
and 
	cogs is null;


-- set the below before deleting a record having a primary keys
set SQL_SAFE_UPDATES = 0;
delete from retail_sales
where 
    transactions_id is null
    or
    sale_date is null
    or
    sale_time is null
    or
    gender is null
    or
    category is null
    or
    quantity is null
    or
    cogs is null
    or
    total_sale is null;

set SQL_SAFE_UPDATES = 1;


-- DATA EXPLORATION

-- how many sales we have
select 
	count(*) as Total_Sales 
from 
	retail_sales;

-- how many unique customer we have
select 
	count(distinct customer_id) 
from 
	retail_sales;


-- Data Analysis & Business Key Problems & Answers
select * 
from 
	retail_Sales;


-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * 
from 
	retail_sales
where 
	sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select * 
from 
	retail_sales 
where 
	category = 'Clothing' 
and 
	quantity >= 4 
and  
	date_format(sale_date, '%Y-%m') = '2022-11';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select 
	category, 
	sum(total_sale) 
from 
	retail_sales 
group by 
	category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
	avg(age) 
from 
	retail_sales 
where 
	category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * 
from 
	retail_sales 
where 
	total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select 
	category, 
	gender, 
	count(transactions_id) 
from 
	retail_sales
group by 
	gender, 
	category 
order by 
	category, gender;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select 
	extract(YEAR from sale_date) as Year, 
	extract(MONTH from sale_date) as Month, 
	avg(total_sale) 
from 
	retail_sales 
group by 1, 2 
order by 1, 2;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

select 
	customer_id, 
	sum(total_sale) 
from 
	retail_sales 
group by 
	customer_id 
order by 2 desc 
limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select 
	category, 
	count(distinct customer_id) 
from 
	retail_sales 
group by 
	category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
select *,
	CASE
		when extract(HOUR from sale_time) > 12 then 'Morning'
        when extract(HOUR from sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
	end as shift
from retail_sales;