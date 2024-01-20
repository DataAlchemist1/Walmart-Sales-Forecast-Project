CREATE DATABASE WalmartSalesData;
-- Creation of Walmart Sales Database.

USE WalmartSalesData; 
-- Selecting the specific database to query.

CREATE TABLE IF NOT EXISTS Walmart_Sales(
Invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL,
tax_pct FLOAT(6,4) NOT NULL,
total DECIMAL(12, 4) NOT NULL,
date DATETIME NOT NULL,
time TIME,
payment VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT(11,9),
gross_income DECIMAL(12, 4),
rating FLOAT(2, 1)
);
-- Creating table for Data with their data type specified.


-- Data cleaning
SELECT * 
FROM Walmart_Sales; 
-- Select All Data form Walmartsalesdata.walmart_sales after data Upload


-- Add the time_of_the_day column
SELECT 
CASE
	WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN 'time' BETWEEN "12:00:01" AND "16:00:00" THEN "Afternoon"
	ELSE "Evening"
	END AS Time_of_the_day
FROM Walmart_Sales;

SELECT
	date,
	DAYNAME(date)
FROM walmart_sales;

ALTER TABLE walmart_sales  ADD COLUMN day_name VARCHAR(10);

SET SQL_SAFE_UPDATES = 0;

UPDATE walmart_sales
SET day_name = DAYNAME(date);

-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM walmart_sales;

ALTER TABLE walmart_sales ADD COLUMN month_name VARCHAR(10);

-- --------------------------------------------------------------------
-- ---------------------------- Questions ------------------------------
-- --------------------------------------------------------------------

-- How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM walmart_sales;

-- In which city is each branch?
SELECT 
	DISTINCT city, branch
FROM walmart_sales;

--  How many unique product lines does the data have?
SELECT 
	DISTINCT product_line
FROM walmart_sales;

-- What is the most selling product line
SELECT 
	SUM(quantity) qtr, 
	product_line
FROM walmart_sales
GROUP BY  product_line
ORDER BY qtr DESC;

-- What is the total revenue by month
SELECT 
	SUM(total) total_revenue, 
    month_name AS month
FROM walmart_sales
GROUP BY month
ORDER BY total_revenue;

-- What month had the largest COGS?
SELECT 
	month_name month, 
    SUM(cogs) AS cogs
FROM walmart_sales
GROUP BY month_name
ORDER BY cogs DESC
LIMIT 1;

-- What product line had the largest revenue?
SELECT 
	product_line, 
    SUM(total) largest_revenue
FROM walmart_sales
GROUP BY product_line
ORDER BY largest_revenue DESC
LIMIT 1;

-- What is the city with the largest revenue?
SELECT 
	city, 
    SUM(total) largest_revenue
FROM walmart_sales
GROUP BY city
ORDER BY largest_revenue DESC
LIMIT 1;

-- What product line had the largest VAT?
SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM walmart_sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

UPDATE walmart_sales
SET month_name = MONTHNAME(date);

-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM walmart_sales;

-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM walmart_sales;

-- What is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM walmart_sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM walmart_sales
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM walmart_sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM walmart_sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Gender per branch is almost the same, This has no 
-- effect on the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM walmart_sales
GROUP BY day_name
ORDER BY avg_rating DESC;
-- The time of the day does not affect the rating, with the highest rating day
-- having less than 1 point higher than the lowest


-- Which time of the day do customers give the most ratings per branch?
SELECT
	day_name, AVG(rating) AS avg_rating
FROM walmart_sales
WHERE branch IN ('A', 'B', 'C')
GROUP BY day_name
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- a little more to get better ratings.


-- Which day of the week has the best average ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM walmart_sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue, and Friday are the best days for good ratings
-- Why is that the case, how many sales are made these days?

-- Number of sales made in each day per weekday 
SELECT
	day_name,
	COUNT(*) AS total_sales
FROM walmart_sales
GROUP BY day_name 
ORDER BY total_sales DESC;
-- Tuesday experience most sales
-- Followed by Wednesday

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM walmart_sales
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percentage?
SELECT
	City,
    ROUND(AVG(tax_pct), 2) avg_tax_pct
FROM walmart_sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM walmart_sales
GROUP BY customer_type
ORDER BY total_tax;
