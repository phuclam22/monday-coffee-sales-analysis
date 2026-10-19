-- PHASE 1: MARKET SIZE & EXPLORATION
-- Q1
-- Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?
SELECT city_name,
	population,
	CAST(population * 0.25 / 1000000.0 AS DECIMAL(10, 2)) AS estimated_consumers_in_million
FROM city
ORDER BY estimated_consumers_in_million DESC;

-- Q2
-- Sales Count for Each Product
-- How many units of each coffee product have been sold?
SELECT p.product_id,
	p.product_name,
	count(s.sale_id) AS total_orders
FROM products AS p
LEFT JOIN sales AS s ON p.product_id = s.product_id
GROUP BY p.product_id,
	p.product_name
ORDER BY total_orders DESC;

-- Q3
-- Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?
SELECT ci.city_name,
	count(DISTINCT c.customer_id) AS unique_customers
FROM city AS ci
JOIN customers AS c ON ci.city_id = c.city_id
JOIN sales AS s ON s.customer_id = c.customer_id
JOIN products AS p ON s.product_id = p.product_id
WHERE p.product_name LIKE '%Coffee%'
	OR p.product_name LIKE '%Espresso%'
	OR p.product_name LIKE '%Brew%'
GROUP BY ci.city_name
ORDER BY unique_customers DESC;




-- PHASE 2: BUSINESS PERFORMANCE & TRENDS
-- Q4
-- Average Sales Amount per City
-- What is the average sales amount per customer in each city?
SELECT ci.city_name,
	sum(s.total) AS total_revenue,
	count(DISTINCT s.customer_id) AS unique_customers,
	cast(sum(s.total) * 1.0 / count(DISTINCT s.customer_id) AS DECIMAL(10, 4)) AS avg_sale_per_customer
FROM sales AS s
JOIN customers AS c ON s.customer_id = c.customer_id
JOIN city AS ci ON c.city_id = ci.city_id
GROUP BY ci.city_name
ORDER BY avg_sale_per_customer DESC;

-- Q5
-- Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
WITH Q4_2023_Sales
AS (
	SELECT customer_id,
		total
	FROM sales
	WHERE Datepart(year, sale_date) = 2023
		AND Datepart(quarter, sale_date) = 4
	)
SELECT ci.city_name,
	sum(q.total) AS total_revenue
FROM Q4_2023_Sales AS q
JOIN customers AS c ON q.customer_id = c.customer_id
JOIN city AS ci ON c.city_id = ci.city_id
GROUP BY ci.city_name
ORDER BY total_revenue DESC;

-- Q6
-- Monthly Sales Growth
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly) by each city.
WITH Monthly_City_Sales
AS (
	SELECT ci.city_name,
		YEAR(s.sale_date) AS sale_year,
		MONTH(s.sale_date) AS sale_month,
		SUM(s.total) AS current_month_sales
	FROM sales AS s
	JOIN customers AS c ON s.customer_id = c.customer_id
	JOIN city AS ci ON c.city_id = ci.city_id
	GROUP BY ci.city_name,
		YEAR(s.sale_date),
		MONTH(s.sale_date)
	),
Sales_With_LAG
AS (
	SELECT city_name,
		sale_year,
		sale_month,
		current_month_sales,
		LAG(current_month_sales, 1) OVER (
			PARTITION BY city_name ORDER BY sale_year,
				sale_month
			) AS prev_month_sales
	FROM Monthly_City_Sales
	)
SELECT city_name,
	sale_year,
	sale_month,
	current_month_sales,
	prev_month_sales,
	CAST(((current_month_sales - prev_month_sales) * 100.0) / NULLIF(prev_month_sales, 0) AS DECIMAL(10, 2)) AS growth_rate_percentage
FROM Sales_With_LAG
WHERE prev_month_sales IS NOT NULL
ORDER BY city_name,
	sale_year,
	sale_month;




-- PHASE 3: BEHAVIOUR & UNIT ECONOMICS
-- Q7
-- Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?
WITH city_product_sales
AS (
	SELECT ci.city_id,
		ci.city_name,
		p.product_name,
		count(s.sale_id) AS total_orders
	FROM sales AS s
	JOIN products AS p ON s.product_id = p.product_id
	JOIN customers AS c ON s.customer_id = c.customer_id
	JOIN city AS ci ON c.city_id = ci.city_id
	GROUP BY ci.city_id,
		ci.city_name,
		p.product_name
	),
ranked_products
AS (
	SELECT city_id,
		city_name,
		product_name,
		total_orders,
		DENSE_RANK() OVER (
			PARTITION BY city_name ORDER BY total_orders DESC
			) AS product_rank
	FROM city_product_sales
	)
SELECT city_id,
	city_name,
	product_name,
	total_orders,
	product_rank
FROM ranked_products
WHERE product_rank <= 3
ORDER BY city_id,
	product_rank;

-- Q8
-- Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer
SELECT ci.city_name,
	ci.estimated_rent,
	count(DISTINCT s.customer_id) AS unique_customers,
	cast(sum(s.total) * 1.0 / count(DISTINCT s.customer_id) AS DECIMAL(10, 2)) AS avg_sale_per_customer,
	cast(ci.estimated_rent / count(DISTINCT s.customer_id) AS DECIMAL(10, 2)) AS avg_rent_per_customer
FROM sales AS s
JOIN customers AS c ON s.customer_id = c.customer_id
JOIN city AS ci ON c.city_id = ci.city_id
GROUP BY ci.city_name,
	ci.estimated_rent
ORDER BY avg_sale_per_customer DESC;




-- PHASE 4: STRATEGIC RECOMMENDATIONS
-- Q9
-- City Population and Coffee Consumers
-- Provide a list of cities along with their populations and estimated coffee consumers.
WITH City_TAM
AS (
	SELECT city_id,
		city_name,
		cast(population * 0.25 / 1000000 AS DECIMAL(10, 2)) AS estimated_consumers_in_million
	FROM city
	),
current_customers
AS (
	SELECT ci.city_id,
		ci.city_name,
		count(DISTINCT s.customer_id) AS unique_customers
	FROM sales AS s
	JOIN customers AS c ON s.customer_id = c.customer_id
	JOIN city AS ci ON c.city_id = ci.city_id
	GROUP BY ci.city_id,
		ci.city_name
	)
SELECT x.city_id,
	x.city_name,
	x.estimated_consumers_in_million,
	y.unique_customers
FROM City_TAM AS x
JOIN current_customers AS y ON x.city_id = y.city_id
ORDER BY x.estimated_consumers_in_million DESC;

-- Q10
-- Market Potential Analysis
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer
SELECT TOP 3 ci.city_name,
	SUM(s.total) AS total_sale,
	ci.estimated_rent AS total_rent,
	COUNT(DISTINCT s.customer_id) AS total_customers,
	CAST((ci.population * 0.25) / 1000000.0 AS DECIMAL(10, 2)) AS estimated_coffee_consumer_in_millions,
	CAST((SUM(s.total) * 1.0) / COUNT(DISTINCT s.customer_id) AS DECIMAL(10, 2)) AS avg_sale_per_cx,
	CAST((ci.estimated_rent * 1.0) / COUNT(DISTINCT s.customer_id) AS DECIMAL(10, 2)) AS avg_rent_per_cx
FROM sales AS s
JOIN customers AS c ON s.customer_id = c.customer_id
JOIN city AS ci ON c.city_id = ci.city_id
GROUP BY ci.city_name,
	ci.estimated_rent,
	ci.population
ORDER BY total_sale DESC;


-- PHASE 5: CUSTOMER INTELLIGENCE
-- Q11
-- Customer Retention
-- What percentage of customers who made a purchase in 2023 returned to make another purchase in 2024?
WITH Cohort_2023
AS (
	SELECT DISTINCT customer_id
	FROM sales
	WHERE year(sale_date) = 2023
	),
Retained_2024
AS (
	SELECT DISTINCT customer_id
	FROM sales
	WHERE year(sale_date) = 2024
		AND customer_id IN (
			SELECT customer_id
			FROM Cohort_2023
			)
	)
SELECT (
		SELECT count(*)
		FROM Cohort_2023
		) AS total_customers_2023,
	(
		SELECT count(*)
		FROM Retained_2024
		) AS retained_customers_2024,
	CAST((
			SELECT count(*)
			FROM Retained_2024
			) * 100.0 / (
			SELECT count(*)
			FROM Cohort_2023
			) AS DECIMAL(10, 2)) AS retention_rate_percentage;

-- Q12
-- RFM Segmentation
-- Segment the customer base into 'VIP', 'Regular', and 'At Risk / Lost' categories by applying the RFM (Recency, Frequency, Monetary) scoring model to evaluate their purchasing behavior and value to the business.
WITH RFM_Base
AS (
	SELECT c.customer_id,
		c.customer_name,
		ci.city_name,
		MAX(s.sale_date) AS last_purchase_date,
		COUNT(s.sale_id) AS frequency,
		sum(s.total) AS monetary
	FROM sales AS s
	JOIN customers AS c ON s.customer_id = c.customer_id
	JOIN city AS ci ON c.city_id = ci.city_id
	GROUP BY c.customer_id,
		c.customer_name,
		ci.city_name
	),
RFM_Scoring
AS (
	SELECT customer_id,
		customer_name,
		city_name,
		DATEDIFF(DAY, last_purchase_date, (
				SELECT MAX(sale_date)
				FROM sales
				)) AS recency_days,
		frequency,
		monetary,
		NTILE(3) OVER (
			ORDER BY datediff(day, last_purchase_date, (
						SELECT MAX(sale_date)
						FROM sales
						)) DESC
			) AS r_score,
		Ntile(3) OVER (
			ORDER BY frequency ASC
			) AS f_score,
		ntile(3) OVER (
			ORDER BY monetary ASC
			) AS m_score
	FROM RFM_Base
	)
SELECT customer_id,
	customer_name,
	city_name,
	recency_days,
	frequency,
	monetary,
	(r_score + f_score + m_score) AS total_rfm_score,
	CASE 
		WHEN (r_score + f_score + m_score) >= 8
			THEN '1. VIP Customer'
		WHEN (r_score + f_score + m_score) >= 5
			THEN '2. Regular Customer'
		ELSE '3. At Risk / Lost'
		END AS customer_segment
FROM RFM_Scoring
ORDER BY customer_segment ASC,
	monetary DESC;




