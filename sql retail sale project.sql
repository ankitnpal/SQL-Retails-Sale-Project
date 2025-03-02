-- SQL RETAIL SALES ANALYTICS P1 --
CREATE DATABASE sql_project_P1;

-- CREATE SQL TABLE --
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
				(
					transactions_id INT PRIMARY KEY,
					sale_date DATE,
					sale_time TIME,
					customer_id INT,
					gender VARCHAR(10),
					age INT,
					category VARCHAR(15),
					quantiy INT,
					price_per_unit FLOAT,
					cogs FLOAT,
					total_sale FLOAT
				)
                
SELECT * FROM retail_sales
LIMIT 10;

SELECT 
	COUNT(*)
FROM retail_sales;

-- DATA CLEANING --
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR
    gender IS NULL OR age IS NULL OR category IS NULL OR quantiy IS NULL OR price_per_unit IS NULL
    OR cogs IS NULL OR total_sale IS NULL;
    
-- DATE EXPLORATION --
-- HOW MANY SALES WE HAVE ?
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- HOW MANY UNIQUE CUSTOMERS WE HAVE ?
SELECT count(distinct(customer_id)) AS total_customer FROM retail_sales;

-- HOW MANY UNIQUE CATEGORY WE HAVE ?
SELECT distinct category AS total_category FROM retail_sales;

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS & SOLUTIONS
-- DATA ANALYSIS & FINDING
-- Q1 Write a SQL query to retrieve all columns for sales made on '2022-11-05.
		SELECT * 
        FROM retail_sales
		WHERE 
			sale_date = '2022-11-05';
-- Q2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.
		SELECT *
        FROM retail_sales
        WHERE 
			category ='clothing'
            AND
            YEAR(sale_date) = 2022
            AND
            MONTH(sale_date) = 11
            AND 
            quantiy >= 4;
-- Q3 Write a SQL query to calculate the total sales (total_sale) for each category.
		SELECT 
			category,
			SUM(total_sale) AS total_sales,
            COUNT(*) AS total_order
        FROM retail_sales
        GROUP BY category;
        
-- Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
		SELECT 
			category,
            AVG(age)
        FROM retail_sales
        WHERE category = 'Beauty'
        GROUP BY category;
-- Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
		SELECT * 
        FROM retail_sales
        WHERE total_sale > 1000;
-- Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
		SELECT 
			gender,
            category,
            COUNT(transactions_id) AS total_trans
		FROM retail_sales
        GROUP BY category, gender;
			
-- Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
					SELECT 
					   year,
					   month,
					avg_sale
					FROM 
					(    
					SELECT 
						EXTRACT(YEAR FROM sale_date) as year,
						EXTRACT(MONTH FROM sale_date) as month,
						AVG(total_sale) as avg_sale,
						RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rnk
					FROM retail_sales
					GROUP BY year, month
					) as t1
					WHERE rnk = 1;
-- Q8 Write a SQL query to find the top 5 customers based on the highest total sales.
		SELECT 
			customer_id,
            SUM(total_sale) AS total_sale
        FROM retail_sales
        GROUP BY customer_id
        ORDER BY total_sale DESC 
        LIMIT 5;
-- Q9 Write a SQL query to find the number of unique customers who purchased items from each category.
		SELECT 
			COUNT(DISTINCT(customer_id)) AS count_no,
            category
		FROM retail_sales
        GROUP BY category;
-- Q10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).
		WITH hourly_sales
        AS(
			SELECT 
				CASE
					WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
                    WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
                    ELSE 'Evening'
                END AS shift
			FROM retail_sales
        )
        SELECT
			shift,
            COUNT(*) AS total_sale
		FROM hourly_sales
        GROUP BY shift
