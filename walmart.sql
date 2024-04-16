SELECT * FROM salesdatawalmart.sales;
-- -------------------------------------
-- ---------- Feature Engineering-------


-- time_of_day--
select time,
	(CASE 
		When time between "00:00:00" and "12:00:00"
			then "Morning"
		When time between "12:01:00" and "16:00:00"
			then "Afternoon"
		else "Evening"
	End) as time_of_day
from sales;

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = 
	(CASE 
		When time between "00:00:00" and "12:00:00"
			then "Morning"
		When time between "12:01:00" and "16:00:00"
			then "Afternoon"
		else "Evening"
	End);
    
    
-- day_name -- 
select date,
	dayname(date)
from sales;


alter table sales add column date_name varchar(10);

update sales set date_name = dayname(date);


-- month_name -- 
select date,
	monthname(date)
from sales;


alter table sales add column month_name varchar(10);

update sales set month_name = monthname(date);


-- -------------------
-- Generic Question --
-- -------------------

-- How many unique cities does the data have?
select count(distinct city) from sales;

select distinct city, branch from sales;

-- ----------
-- Product --
-- ----------

-- How many unique product lines does the data have?
select count(distinct product_line) from sales;

-- What is the most common payment method?
select payment, count(payment)
from sales
group by payment;

-- What is the most selling product line?
select SUM(quantity) as qty,
	   product_line
from sales
group by product_line
order by qty desc;

-- What is the total revenue by month?
select month_name as month, sum(total) as total_revenue
from sales
group by month_name
order by total_revenue;

-- What month had the largest COGS
select month_name as month, sum(cogs) as month_cogs
from sales
group by month_name
order by month_cogs desc
;

-- What product line had the largest revenue?
select product_line, sum(total) as total_revenue 
from sales
group by product_line
order by total_revenue desc
;

-- What is the city with the largest revenue?
select city, sum(total) as total_revenue 
from sales
group by city
order by total_revenue desc
;

-- What product line had the largest VAT?
SELECT product_line, AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select sum(quantity) / count(distinct product_line) from sales;

select 
	product_line, sum(quantity)  as total_qty,
    case
		When sum(quantity) >= (select sum(quantity) / count(distinct product_line) from sales)
			then "Good"
		When sum(quantity) < (select sum(quantity) / count(distinct product_line) from sales)
			then "Bad"
	end as result
from sales
group by product_line
order by total_qty desc;
            

-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (select  sum(quantity)/ count(distinct branch) from sales);

-- What is the most common product line by gender?
Select product_line, gender, count(gender) as cnt
from sales
group by product_line, gender
order by cnt desc;

-- What is the average rating of each product line?
select product_line, round(avg(rating), 2) as avg_rating
from sales
group by product_line
order by avg_rating desc;


-- ---------------------------------------------------
-- Sales ---------------------------------------------
-- ---------------------------------------------------

-- Number of sales made in each time of the day per weekday

SELECT
	date_name,
	time_of_day,
	sum(total) AS total_sales
FROM sales
GROUP BY date_name, time_of_day
ORDER BY CASE 
     WHEN date_name = "Monday"    THEN 1
     WHEN date_name = "Tuesday"   THEN 2
     WHEN date_name = "Wednesday" THEN 3
     WHEN date_name = "Thursday"  THEN 4
     WHEN date_name = "Friday"    THEN 5
     WHEN date_name = "Saturday"  THEN 6
     WHEN date_name = "Sunday"    THEN 7
     END ASC,
     
     CASE
     WHEN time_of_day = "Morning"   THEN 1
     WHEN time_of_day = "Afternoon" THEN 2
     WHEN time_of_day = "Evening"   THEN 3
     END ASC;
     
-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
    sum(Total) as total_revenue
FROM sales
group by customer_type
order by total_revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, round(avg(tax_pct), 2) as VAT_of_city
from sales
group by city
order by VAT_of_city desc;

-- Which customer type pays the most in VAT?
select customer_type, round(avg(tax_pct), 2) as VAT
from sales
group by customer_type
order by VAT desc;



-- ----------------------------------
-- Customer--------------------------
-- ----------------------------------


-- How many unique customer types does the data have?
select count(distinct customer_type) as number_of_unique_customer_types from sales;

-- How many unique payment methods does the data have?
select count(distinct payment) as number_of_paymentr_types from sales;

-- What is the most common customer type?
select customer_type, count(customer_type) as customer_cnt
from sales
group by customer_type
order by customer_cnt desc;

-- Which customer type buys the most?
select customer_type, sum(total) as customer_purchase
from sales
group by customer_type
order by customer_purchase desc;

-- What is the gender of most of the customers?
select gender, count(*) as cnt
from sales
group by gender
order by cnt desc;

-- What is the gender distribution per branch?
select branch, gender, count(gender) as gender_cnt
from sales
group by branch, gender
order by branch, gender;

-- Which time of the day do customers give most ratings?
select time_of_day, round(avg(rating), 2) as rating
from sales
group by time_of_day
order by rating desc;

-- Which time of the day do customers give most ratings per branch?
select branch, time_of_day, round(avg(rating), 2) as rating
from sales
group by branch, time_of_day
order by branch, rating desc;

-- Which day of the week has the best avg ratings?
select date_name, round(avg(rating), 2) as avg_rating
from sales
group by date_name
order by avg_rating desc;

-- Which day of the week has the best average ratings per branch?
select branch, date_name, round(avg(rating), 2) as avg_rating
from sales
group by branch, date_name
order by branch, avg_rating desc;