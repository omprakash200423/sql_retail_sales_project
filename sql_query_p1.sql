--sql Retail Sales Analysis
create database sql_project_p1;

--create Table
drop table if exists retail_sales;
CREATE TABLE retail_sales 
	(
    	transactions_id INT PRIMARY KEY,
    	sale_date DATE,
    	sale_time TIME,
    	customer_id INT,
    	gender VARCHAR(10),
    	age INT,
    	category VARCHAR(50),
    	quantity INT,
    	price_per_unit FLOAT,
    	cogs FLOAT,
    	total_sale FLOAT
	);



select * from retail_sales
limit 100;



select
	count(*)
from retail_Sales;

--Data Cleaning

select * from retail_sales
where   transactions_id is null
		OR
		sale_date is null
		OR
		sale_time is null
		OR
		customer_id is null
		OR
		gender is null 
		OR
		category is null
		OR
		quantity is null
		OR
		price_per_unit is null
		OR
		cogs is null
		OR
		total_sale is null;


delete from retail_sales 
where   transactions_id is null
		OR
		sale_date is null
		OR
		sale_time is null
		OR
		customer_id is null
		OR
		gender is null 
		OR
		category is null
		OR
		quantity is null
		OR
		price_per_unit is null
		OR
		cogs is null
		OR
		total_sale is null;

--Data Exploration

--how many sales we have?
select count(*) from retail_sales;

--how many unique customers do we have?
select count(distinct customer_id) from retail_sales;

--how many categories do we have?
select distinct category from retail_sales;

--Data Analysis & Bussiness problems and Answers
/*
1.Write a SQL query to retrieve all columns for sales made on 2022-11-05.
2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.
3.Write a SQL query to calculate the total sales (total_sale) for each category.
4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
8.Write a SQL query to find the top 5 customers based on the highest total sales.
9.Write a SQL query to find the number of unique customers who purchased items from each category.
10.Write a SQL query to create each shift and number of orders (Example: Morning <=12, Afternoon Between 12 & 17, Evening >17)
*/


--1.Write a sql query to retrive all columns for sales made on '2022-11-05'

select 
	*
from retail_sales
where sale_date='2022-11-05';

 
--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.

select 
	*
from retail_sales
where (category='Clothing') 
		and
	((quantity>=4) 
			and 
			sale_date between '2022-11-01' and'2022-11-30');

--3.Write a SQL query to calculate the total sales (total_sale) for each category.

select 
	category,
	sum(total_sale) as net_sales,
	count(*) as total_orders
from retail_sales
group by 1;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
	round(avg(age))
from retail_sales
where category='Beauty';



--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.

select 
	* 
from retail_sales
where total_Sale>1000;



--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.


select 
	category,
	gender,
	sum(total_sale) as net_amount,
	count(*) as total_transactions

from retail_sales
group by 1,2
order by category;


--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

select 
	years,
	months,
	average_sales
from	(select 
			extract(year from sale_date) as years,
			extract(month from sale_date) as months,
			round(avg(total_sale)) as average_sales,
			rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc)
			from retail_sales
			group by 1,2) as t
where rank=1;

--8.Write a SQL query to find the top 5 customers based on the highest total sales.

select 
	customer_id,
	sum(total_sale) as top_sales
from retail_sales
group by customer_id
order by 2 desc
limit 5;


--9.Write a SQL query to find the number of unique customers who purchased items from each category.

select 
	category,
	count(distinct customer_id) as unique_count
from retail_sales
group by category;


--10.Write a SQL query to create each shift and number of orders (Example: Morning <12, Afternoon Between 12 & 17, Evening >17).

with hourly as 
	(
		select *,
			case
				when extract(hour from sale_time)<12 then 'Morning'
				when extract(hour from sale_time) between 12 and 17 then 'Aternoon'
				else 'Evening'
				end as shift
		from 
			retail_sales)

select 
	shift,
	count(*) as num_of_orders
from hourly
group by shift;


--end of the project