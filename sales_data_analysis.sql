-- Sales Data Analysis 


-- Basic questions

-- Total records
select count(*) from sales_data_sample


-- Distinct productline
select distinct productline from sales_data_sample


-- Total sales made in 2024

select sum(cast(sales as decimal(10,2))) as Sales_in_2004
from sales_data_sample
where year_id = 2004

-- Get the number of orders placed by each STATUS (e.g., Shipped, Cancelled).

select STATUS, sum(cast(quantityordered as decimal)) as sum_of_order
from sales_data_sample
group by status
order by sum_of_order asc


--List the customers who made more than 3 orders.

select customername, orderlinenumber
from sales_data_sample
where ORDERLINENUMBER > 3
order by ORDERLINENUMBER desc




-- Intermediate Level

--Calculate the total revenue (SALES) for each PRODUCTLINE.

select * from sales_data_sample

select PRODUCTLINE, SUM(CAST(SALES AS DECIMAL(10,2))) AS TOTAL_REVENUE
FROM sales_data_sample
GROUP BY PRODUCTLINE


-- Find the average price (PRICEEACH) per product line.

SELECT PRODUCTLINE, AVG(CAST(PRICEEACH AS DECIMAL(10,2))) AS AVG_PRICE
FROM sales_data_sample
GROUP BY PRODUCTLINE


-- List the top 5 customers by total purchase amount (SALES).

SELECT TOP 5 CUSTOMERNAME, SUM(CAST(SALES AS DECIMAL(10,2))) AS TOTAL_PURCHASE_AMOUNT 
FROM sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY TOTAL_PURCHASE_AMOUNT DESC

--Find the month with the highest total sales in the year 2004.

SELECT TOP 1 MONTH_ID, SUM(CAST(SALES AS DECIMAL(10,2))) AS TOTAL_AMOUNT 
FROM sales_data_sample
WHERE YEAR_ID = 2004
GROUP BY MONTH_ID
ORDER BY TOTAL_AMOUNT DESC

-- Show the customer name, city, and total sales they generated

SELECT CUSTOMERNAME, CITY, SUM(CAST(SALES AS DECIMAL(10,2))) AS TOTAL_SALES
FROM sales_data_sample
GROUP BY CUSTOMERNAME,CITY
ORDER BY TOTAL_SALES DESC


--Advanced Level (Analyst Role) 

-- 
SELECT 
    CUSTOMERNAME,
    SUM(CAST(SALES AS DECIMAL(10,2))) AS TotalSales,
    RANK() OVER (ORDER BY SUM(CAST(SALES AS DECIMAL(10,2))) DESC) AS SalesRank
FROM 
    sales_data_sample
GROUP BY 
    CUSTOMERNAME
ORDER BY 
    SalesRank;


-- Show the percentage contribution of each product line to the total sales.
SELECT PRODUCTLINE, SUM(CAST(SALES AS DECIMAL(10,2))) AS TOTAL_SALES, ROUND(SUM(CAST(SALES AS DECIMAL(10,2)))*100/ (SELECT SUM(CAST(SALES AS DECIMAL(10,2))) FROM sales_data_sample),2) AS PERCENTAGE_CONTRIBUTION
FROM sales_data_sample
GROUP BY PRODUCTLINE
ORDER BY TOTAL_SALES DESC


-- Identify if any customer has placed orders in more than one year.

SELECT  CUSTOMERNAME, COUNT(DISTINCT(YEAR_ID)) AS COUNT_YEAR
FROM sales_data_sample
GROUP BY CUSTOMERNAME
HAVING COUNT(DISTINCT YEAR_ID) > 1
ORDER BY CUSTOMERNAME ASC

-- List product lines whose total sales are above the average of all product lines.

SELECT PRODUCTLINE, SUM(CAST(SALES AS DECIMAL(10,2))) AS TOTAL_SALES
FROM sales_data_sample
GROUP BY PRODUCTLINE
HAVING SUM(CAST(SALES AS DECIMAL(10,2))) > (SELECT AVG(PRODUCTSALES.TOTAL_SALES)
FROM ( SELECT PRODUCTLINE, SUM(CAST(SALES AS DECIMAL(10,2))) AS TOTAL_SALES
FROM sales_data_sample
GROUP BY PRODUCTLINE) 
AS PRODUCTSALES )

ORDER BY TOTAL_SALES DESC

-- Create a report of monthly sales trends (total sales by MONTH_ID and YEAR_ID).
SELECT MONTH_ID, YEAR_ID, SUM(CAST(SALES AS DECIMAL(10,2))) AS TOTAL_SALES
FROM sales_data_sample
GROUP BY MONTH_ID, YEAR_ID
ORDER BY TOTAL_SALES,MONTH_ID,YEAR_ID DESC



/*  Question 4: CASE + Aggregation
 "Classify each sale into performance buckets based on the SALES amount:

High if SALES >= 5000

Medium if SALES >= 2000 AND < 5000

Low if < 2000
Then, count how many sales fall into each bucket."** 
*/

SELECT
CASE
	WHEN CAST(SALES AS DECIMAL(10,2)) >=5000 THEN 'HIGH'
	WHEN CAST(SALES AS DECIMAL(10,2)) >=2000 THEN 'MEDIUM'
	ELSE 'LOW'
END AS SALES_BUCKET,
COUNT(*) AS SALES_COUNT
FROM SALES_DATA_SAMPLE
GROUP BY 
	CASE
	WHEN CAST(SALES AS DECIMAL(10,2)) >=5000 THEN 'HIGH'
	WHEN CAST(SALES AS DECIMAL(10,2)) >=2000 THEN 'MEDIUM'
	ELSE 'LOW'
END

/*
Question 5: Subquery + Filtering Top Records
"Find customers whose total sales are above the average total sales of all customers."

 Requirements:
Use a subquery to calculate average total sales across all customers

Use SUM(CAST(SALES ...)) to get total sales per customer

Return only customers whose total sales are greater than that average

Show columns: CUSTOMERNAME, TOTAL_SALES
*/


SELECT CUSTOMERNAME, SUM(CAST(SALES AS DECIMAL(10,2))) AS TOTAL_SALES
FROM sales_data_sample
GROUP BY CUSTOMERNAME
HAVING SUM(CAST(SALES AS DECIMAL(10,2))) > (SELECT AVG(PRODUCTSALES.TOTAL_SALES)
FROM ( SELECT CUSTOMERNAME, SUM(CAST(SALES AS DECIMAL(10,2))) AS TOTAL_SALES
FROM sales_data_sample
GROUP BY CUSTOMERNAME) 
AS PRODUCTSALES )

ORDER BY TOTAL_SALES DESC