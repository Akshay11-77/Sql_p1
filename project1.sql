create database sql_Project_Reatilanalysis;

-- create table--
drop table if exists retail_sales;
Create Table retail_sales
(
transactions_id	INT PRIMARY KEY,
sale_date DATE,	
sale_time TIME,	
customer_id	INT,
gender VARCHAR(15),	
age	INT,
category VARCHAR(15),	
quantiy	INT,
price_per_unit FLOAT,	
cogs FLOAT,	
total_sale FLOAT
);

Select * from retail_sales
LIMIT 10;

Select
count(*)
from retail_sales;

-- data cleaning--

Select * from retail_sales
WHERE transactions_id is NULL;

select * from retail_sales
where sale_date is NULL;

select * from retail_sales
where
		transactions_id is NULL
		OR
		sale_date is NULL
		OR
		sale_time is NULL
		OR
		customer_id is NULL
		OR
		gender is NULL
		OR
		age is NULL
		OR
		category is NULL
		OR
		quantiy is NULL
		OR
		price_per_unit is NULL
		OR
		cogs is NULL
		OR 
		total_sale is NULL;
		
		
Delete from retail_sales
where
transactions_id is NULL
		OR
		sale_date is NULL
		OR
		sale_time is NULL
		OR
		customer_id is NULL
		OR
		gender is NULL
		OR
		age is NULL
		OR
		category is NULL
		OR
		quantiy is NULL
		OR
		price_per_unit is NULL
		OR
		cogs is NULL
		OR 
		total_sale is NULL;

-- data exploration --

-- how many sales we have --
select count(*) as total_sale from retail_sales;

-- how many unique customers we have --
select count(distinct customer_id) as unique_customers from retail_sales;
select distinct customer_id as unique_customers from retail_sales;

-- how many categories do we have --

select count(distinct category) as Categories from retail_sales;
select distinct category as Categories from retail_sales;

-- data analysis and Key Business Problems and Answers --

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select *
FROM retail_sales
where sale_date ='2022-11-05';

--2. Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--   and the quantity sold is more than 1, but less than 4 in the month of Nov_2022:

select *
FROM retail_sales
where 
category = 'Clothing'
AND
quantiy >1 AND quantiy < 4
AND 
to_char(sale_date,'YYYY-MM') = '2022-11';

--3. Write a SQL query to calculate the total sales (total_sale) and total orders
--   for each category.:

Select category,
SUM(total_sale),
COUNT(*)
FROM retail_sales
GROUP BY 1;

-- 4. Write a SQL query to find the average age of 
--    customers who purchased items from the 'Beauty' category.:

Select 
ROUND(AVG(age),2) as AVG_age from retail_sales
where category ='Beauty';

--5. Write a SQL query to find all transactions 
--   where the total_sale is greater than 1000.:

Select * FROM retail_sales
where total_sale > 1000;


--6. Write a SQL query to find the total number of transactions (transaction_id) 
--   made by each gender in each category.:

SELECT category, gender, COUNT(transactions_id) as Count_Of_TransactionID
from retail_sales
GROUP BY 1,2
ORDER BY 1;

--7. Write a SQL query to calculate the average sale 
--   for each month. Find out best selling month in each year:

Select 
Year, Month, Avg_Sale
FROM
(Select 
Extract(Year from sale_date) as Year,
Extract(Month from sale_date) as Month,
ROUND(AVG(total_sale)::Numeric,2) as Avg_Sale,
Rank() OVER(Partition by Extract(Year from sale_date) Order BY Round(AVG(total_sale)::Numeric,2) DESC) as Rank
From retail_sales
group by 1,2) as t1
WHERE Rank=1;

--8. *Write a SQL query to find the top 5 customers 
--    based on the highest total sales **:

Select customer_id, SUM(total_sale) as Total_sales from retail_sales
group by 1
order by 2 desc
limit 5;

--9. Write a SQL query to find the number of unique 
--   customers who purchased items from each category.:

Select category, count(distinct customer_id) as count_Of_UniqueCustomers 
from retail_sales
group by 1;

--10. Write a SQL query to create each shift and number of orders 
--    (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

With hourly_sales as
(Select *,
CASE
	When Extract(Hour from sale_time) < 12 then 'Morning'
	When Extract (Hour from sale_time) between 12 and 17 then 'Afternoon'
	Else 'Evening'
End as Shift
FROM retail_sales)

Select Shift, Count(transactions_id) as No_of_Orders from hourly_sales
Group by Shift;









		