-- EDA

SELECT * FROM Customers;
SELECT * FROM Restaurants;
SELECT * FROM Orders;
SELECT * FROM Riders;
SELECT * FROM Deliveries;

-- Import Datasets By direct method



-- Handing NULL values:

SELECT * FROM orders
WHERE
	order_item IS NULL
	OR
	order_date IS NULL
	OR 
	order_time IS NULL
	OR
	order_status IS NULL
	OR 
	total_amount IS  NULL


SELECT * FROM Restaurants
WHERE
	restaurant_name IS NULL
	OR
	city IS NULL
	OR 
	opening_hours IS NULL
	
	
SELECT * FROM customers
WHERE
	customer_name IS NULL
	OR
	reg_date IS NULL

SELECT * FROM Riders 		-- Found NULL at rider_id 38
WHERE
	rider_id IS NULL
	OR
	rider_name IS NULL
	OR 
	sign_up IS NULL

-- delete NULL

DELETE FROM Riders
WHERE
	rider_id IS NULL
	OR
	rider_name IS NULL
	OR 
	sign_up IS NULL


SELECT * FROM Deliveries
WHERE
	delivery_id IS NULL
	OR
	order_id IS NULL
	OR 
	delivery_time IS NULL
	OR
	delivery_status IS NULL
	OR 
	rider_id IS  NULL


-- -------------------------------------
-- Analysis & Reports
-- -------------------------------------




--Q.1
-- write a query to find the 5 top most frequently ordered dishes by customer called 'Priya sharma' in the last 1 year. 

SELECT c.customer_id, c.customer_name, o.order_item AS dishes,
COUNT(*) AS total_orders
FROM Orders as o
JOIN 
customers as c
ON c. customer_id = o.customer_id
WHERE
	o.order_date >= CURRENT_DATE - INTERVAL '1 Year'
	AND
	c.customer_name = 'Arjun Mehta'
GROUP BY 1,2,3
ORDER BY 1,4 DESC




-- Q.2 Popular time slots
-- Identify the time slots during which the most orders are placed based on 2 hour intervals.
SELECT 
	FLOOR(EXTRACT(HOUR FROM order_time)/2)*2 AS start_time,
	FLOOR(EXTRACT(HOUR FROM order_time)/2)*2 * 2 AS end_time,
	COUNT(*) AS total_orders

FROM Orders
GROUP BY 1,2
ORDER BY 3 DESC


SELECT
	CASE
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '00:00 - 02:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '02:00 - 04:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '04:00 - 06:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '06:00 - 08:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '08:00 - 10:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '10:00 - 12:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '12:00 - 14:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '14:00 - 16:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '16:00 - 18:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '18:00 - 20:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '20:00 - 22:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '22:00 - 00:00'
	END AS time_slot,
	COUNT(order_id) AS order_count
FROM Orders
GROUP BY time_slot
ORDER BY order_count DESC;



--3. Order Values Analysis
-- Find the average order value per customer who has placed more than 5 orders.
-- Return customer_name, and avg(average order value)


SELECT 
	-- customer_id,
	c.customer_name,
	AVG(o.total_amount) AS aov
FROM Orders AS o
	JOIN customers as c
	ON c.customer_id = o.customer_id
GROUP BY 1
HAVING COUNT(order_id) > 5



-- 4. High-Value Customers
-- List the customers who have spent more than 1.5 k in total on food orders
-- return customer_name and customer_id

SELECT 
	-- customer_id,
	c.customer_name,
	AVG(o.total_amount) AS total_spent
FROM Orders AS o
	JOIN customers as c
	ON c.customer_id = o.customer_id
GROUP BY 1
HAVING SUM(o.total_amount) > 1500



-- 5. Order without delivery
-- write a query to find orders that were placed but not delivered.
-- Return each restaurant name, city and number of not deliverd orders
-- Approach 1
SELECT 
	r.restaurant_name,
	COUNT(O.order_id) AS cnt_not_delivered_Orders
FROM orders as o
LEFT JOIN
restaurants as r
ON r.restaurant_id = o.restaurant_id
LEFT JOIN
deliveries as d
ON d.order_id = o.order_id
WHERE d.delivery_id IS NULL
GROUP BY 1
ORDER BY 2 DESC


-- Q.6. Restaurant Revenue Ranking 
-- Rank restaurants by their total revenue from the last year, including their name,
-- total revenue, and rank within their city.
WITH ranking_table
AS
(
SELECT 
	r.city,
	r.restaurant_name,
	SUM(o.total_amount) AS revenue,
	
	RANK() OVER(PARTITION BY r.city ORDER BY SUM(o.total_amount) DESC) AS rank
FROM orders as o
JOIN
restaurants as r
ON r.restaurant_id = o.restaurant_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '1 year' 
GROUP BY 1, 2
)
SELECT
* 
FROM ranking_table
WHERE rank = 1


-- Q.7 Most Popular Dish by City:
-- Identity the most popular dish in each city based on the number of orders
SELECT *
FROM
(SELECT
	r.city,
	o.order_item as dish,
	COUNT(order_id) as total_orders,
	RANK() OVER(PARTITION BY r.city ORDER BY COUNT(order_id) DESC) AS RANK
FROM orders as o
JOIN 
restaurants as r
ON r.restaurant_id = o.restaurant_id
GROUP BY 1,2
) AS t1
WHERE RANK = 1

-- Q.8 Customer Churn:
-- Find customers who hasen't placed an order in 2024 but did in 2023
--find cx who has done orders in 2024
--find cx who has not done orders in 2025

SELECT DISTINCT customer_id FROM orders
WHERE 
	EXTRACT(YEAR FROM order_date) = 2024
	AND
	customer_id NOT IN
	(SELECT DISTINCT customer_id FROM orders
	WHERE EXTRACT(YEAR FROM order_date) = 2025)







-- Q.9 Cancellation Rate Comparison:
-- Calculate and compare the order cancellation rate for each restaurant between the
-- current year and the previous year.
WITH cancel_ratio
AS
	(SELECT 
		o.restaurant_id,
		COUNT(o.order_id) as total_orders,
		COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) not_delivered
	FROM orders as o
	LEFT JOIN 
	deliveries as d
	ON o.order_id = d.order_id
	WHERE EXTRACT(YEAR FROM o.order_date) = 2023
	GROUP BY o.restaurant_id
),
last_year_data
AS
(
SELECT 
	restaurant_id,
	total_orders,
	not_delivered,
	ROUND((
		not_delivered::numeric / total_orders::numeric) * 100,
		2) as cancel_ratio
FROM cancel_ratio_23
), 
cancel_ratio_24
AS
	(SELECT 
		o.restaurant_id,
		COUNT(o.order_id) as total_orders,
		COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) not_delivered
	FROM orders as o
	LEFT JOIN 
	deliveries as d
	ON o.order_id = d.order_id
	WHERE EXTRACT(YEAR FROM o.order_date) = 2024
	GROUP BY 1
),
last_year_data
AS
(
SELECT 
	restaurant_id,
	total_orders,
	not_delivered,
	ROUND(
		not_delivered::numeric / total_orders::numeric * 100,
		2) as cancel_ratio
FROM cancel_ratio_24
)

WITH cancel_ratio
AS
	(SELECT 
		o.restaurant_id,
		COUNT(o.order_id) as total_orders,
		COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) not_delivered
	FROM orders as o
	LEFT JOIN 
	deliveries as d
	ON o.order_id = d.order_id
	WHERE EXTRACT(YEAR FROM o.order_date) = 2023
	GROUP BY 1
),
last_year_data
AS
(
SELECT 
	restaurant_id,
	total_orders,
	not_delivered,
	ROUND(
		not_delivered::numeric / total_orders::numeric * 100,
		2) as cancel_ratio
FROM cancel_ratio
)

WITH cancel_ratio
AS
	(SELECT 
		o.restaurant_id,
		COUNT(o.order_id) as total_orders,
		COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) not_delivered
	FROM orders as o
	LEFT JOIN 
	deliveries as d
	ON o.order_id = d.order_id
	WHERE EXTRACT(YEAR FROM o.order_date) = 2023
	GROUP BY 1
),
last_year_data
AS
(
SELECT 
	restaurant_id,
	total_orders,
	not_delivered,
	ROUND(
		not_delivered::numeric / total_orders::numeric * 100,
		2) as cancel_ratio
FROM cancel_ratio
)

WITH cancel_ratio
AS
	(SELECT 
		o.restaurant_id,
		COUNT(o.order_id) as total_orders,
		COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) not_delivered
	FROM orders as o
	LEFT JOIN 
	deliveries as d
	ON o.order_id = d.order_id
	WHERE EXTRACT(YEAR FROM o.order_date) = 2023
	GROUP BY 1
),
last_year_data
AS
(
SELECT 
	restaurant_id,
	total_orders,
	not_delivered,
	ROUND(
		not_delivered::numeric / total_orders::numeric * 100,
		2) as cancel_ratio
FROM cancel_ratio
)

SELECT 
	current_year_date.restaurant_id as rest_id,
	current_year_date.cancel_ratio as cs_ratio,
	last_year_data.cancel_ratio as ls_c_ratio
FROM current_year_date
JOIN
last_year_data
ON current_year_date.restaurant_id = last_year_data.restaurant_id

-- Q.9 Cancellation Rate Comparison:
-- calculate and compare the order cancellation rate each restaurant between the current year and the previous year.

WITH cancel_ratio_23 AS(
	SELECT
		o.restaurant_id,
		COUNT(o.order_id) AS total_orders,
		COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) AS not_delivered
	FROM orders AS o
	LEFT JOIN deliveries AS d
	ON o.order_id = d.order_id
	WHERE EXTRACT(YEAR FROM o.order_date) = 2024
	GROUP BY o.restaurant_id
),
cancel_ratio_24 AS (
	SELECT
		o.restaurant_id,
		COUNT(o.order_id) AS total_orders,
		COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) AS not_delivered
	FROM orders AS o
	LEFT JOIN deliveries AS d
	ON o.order_id = d.order_id
	WHERE EXTRACT(YEAR FROM o.order_date) = 2023
	GROUP BY o.restaurant_id
),
last_year_data AS (
	SELECT
		restaurant_id,
		total_orders,
		not_delivered,
		ROUND((not_delivered::numeric / total_orders::numeric) * 100, 2) AS cancel_ratio
	FROM cancel_ratio_23
),
current_year_data AS (
	SELECT
		restaurant_id,
		total_orders,
		not_delivered,
		ROUND((not_delivered::numeric / total_orders::numeric) * 100, 2) AS cancel_ratio
	FROM cancel_ratio_24
),

SELECT
	c.restaurant_id AS restaurant_id,
	c.cancel_ration AS current_year_cancel_ratio,
	l.cancel_rtio AS last_year_cancel_ratio
FROM current_year_data AS c
JOIN last_year_data AS l
ON c.restaurant_id = l.restaurant_id;


-- Q.10 Ride Average Delivery Time:
-- Determine each rider's average delivery time.

SELECT
	o.order_id,
	o.order_time,
	d.delivery_time,
	d.rider_id,
	d.delivery_time - o.order_time as time_difference,
	EXTRACT(EPOCH FROM (d.delivery_time - o.order_time +
	CASE WHEN d.delivery_time < o.order_time THEN INTERVAL '1 day' ELSE
	INTERVAL '0 day' END))/60 AS time_difference_in_min
FROM orders as o
JOIN deliveries as d 
ON o.order_id = d.order_id
WHERE d.delivery_status= 'Delivered';

-- Q.11. Monthly Restaurant Growth Ratio:
-- Calculate each restaurant's growth ration based on the total number of deliveries orders since its joining

WITH growth_ratio
AS
(
SELECT 
	o.restaurant_id,
	TO_CHAR(order_date, 'mm-yy') as month,
	COUNT(o.order_id) as current_month_orders,
	LAG(COUNT(o.order_id), 1)OVER(PARTITION BY o.restaurant_id ORDER BY TO_CHAR(o.order_date, 'mm-yy')) as prev_month_orders
FROM orders as o
JOIN
deliveries as d
ON o.order_id = d.order_id
WHERE d.delivery_status = 'Delivered'
GROUP BY 1, 2
ORDER BY 1, 2
)
SELECT 
	restaurant_id,
	month,
	prev_month_orders,
	current_month_orders,
	(current_month_orders::numeric - prev_month_orders::numeric)/prev_month_orders::numeric * 100 AS growth_ratio
FROM growth_ratio



--Q.12 Customer Segmentation:
-- Customer Segmentation: Segment customers into 'Gold' or 'Silver' groups based on total spending
-- compared to the average order value (ADV). If a customer's total spending exceeds the AOV.
-- label them as 'Gold'; otherwise, label them as 'Silver'. Write an SQL query to determine each segment's
-- total number of orders and total revenue

SELECT 
	customer_category,
	SUM(total_orders) as total_orders,
	SUM(total_spent) as total_revenue
FROM
	(SELECT 
		customer_id,
		SUM(total_amount) as total_spent,
		COUNT(order_id) as total_orders,
		CASE
			WHEN SUM(total_amount) > (SELECT AVG(total_amount) FROM orders) THEN 'Gold'
			ELSE 'silver'
		END as customer_category
	FROM orders
	GROUP BY 1
	) AS t1
GROUP BY 1
	
-- Q.13 Rider Monthly Earnings:
-- Calculate each rider's total monthly earnings, assuming they earn 8% of the order amount.
SELECT 
	d.rider_id,
	TO_CHAR(o.order_date, 'mm-yy') as month,
	SUM(total_amount) As revenue,
	SUM(total_amount) * 0.08 as riders_earning
FROM orders as o
JOIN deliveries as d
ON o.order_id = d.order_id
GROUP BY 1,2
ORDER BY 1,2

-- Q.14. Rider Rating Analysis:
-- Find the number of 5-star, 4-star, and 3-star ratings each rider has.
-- riders receive this rating based on delivery time.
-- if orders are delivered less than 15 minutes of order received time the rider get 5 star rating
-- if they deliver 15 and 20 minute they get 4 star rating
-- f they deliver after 20 minute they get 3 star rating.
SELECT
	rider_id,
	stars,
	COUNT(*) AS total_stars
FROM
(
	SELECT
		rider_id,
		delivery_took_time,
		CASE
			WHEN delivery_took_time < 15 THEN '5 STAR'
			WHEN delivery_took_time BETWEEN 5 AND 20 THEN '4 STAR'
			ELSE '3 STAR'
		END as stars
	FROM
	(
		SELECT 
			o.order_id,
			o.order_time,
			d.delivery_time,
			EXTRACT(EPOCH FROM (d.delivery_time - o.order_time +
			CASE WHEN d.delivery_time < o.order_time THEN INTERVAL '1 day'
			ELSE INTERVAL '0 day' END
			))/60 as delivery_took_time,
			d.rider_id
		FROM orders as o
		JOIN deliveries as d
		ON o.order_id = d.order_id
		WHERE delivery_status = 'Delivered'
	) AS t1
) as t2
GROUP BY 1,2
ORDER BY 1,3 DESC


-- Q. 15 Order Frequency by Day:
-- Analyze order frequency per day of the week and identify the peak day for each restaurant
SELECT * FROM
(
	SELECT
		r.restaurant_name,
		o.order_date,
		TO_CHAR(o.order_date, 'Day') as day,
		COUNT(o.order_id) as tota_orders,
		RANK() OVER(PARTITION BY r.restaurant_name ORDER BY COUNT (o.order_id) DESC) AS rank
	FROM orders as o
	JOIN
	restaurants as r
	ON o.restaurant_id = r.restaurant_id
	GROUP BY 1,2
	ORDER BY 1,3 DESC
	) AS t1
WHERE rank = 1


-- Q. 16 Customer Lifetime Value (CLV):
-- Calculate the total revenue generated by each customer over all their orders.
SELECT
	o.customer_id,
	c.customer_name,
	SUM(o.total_amount) as CLV
FROM orders as o
JOIN customers as c
ON o.customer_id = c.customer_id
GROUP BY 1,2

-- Q.17 Monthly Sales Trends:
-- Identity sales trends by comparing each month's total sales to the previous month.

SELECT 
	EXTRACT(YEAR FROM order_date) as year,
	EXTRACT(MONTH FROM order_date) as month,
	SUM(total_amount) as total_sale,
	LAG(SUM(total_amount), 1) OVER(ORDER BY EXTRACT(YEAR FROM order_date),EXTRACT(MONTH FROM order_date)) as prev_month
FROM orders
GROUP BY 1, 2
ORDER BY 1, 2

-- Q. 18 Rider Efficiency:
-- Evaluate rider efficiency by determining average delivery times and identifying those with the lowest and highest averages


WITH new_table
AS
(
	SELECT *,
		d.rider_id AS riders_id,
		EXTRACT(EPOCH FROM (d.delivery_time - o.order_time +
		CASE WHEN d.delivery_time < o.order_time THEN INTERVAL '1 day' ELSE
		INTERVAL '0 day' END))/60 AS time_deliver
	FROM orders as o
	JOIN deliveries as d
	ON o.order_id = d.order_id
	WHERE d.delivery_status = 'Delivered'
),
riders_time
AS
(
	SELECT 
		riders_id,
		AVG(time_deliver) as avg_time
	FROM new_table
	GROUP BY 1
)
SELECT
	MIN(avg_time),
	MAX(avg_time)
FROM riders_time

-- Q.19 Order Item Popularity:
-- Track the popularity of specific order items over time and identify seasonal demand splikes.
SELECT 
	order_item,
	seasons,
	COUNT(order_id) as total_orders

	
FROM
(
SELECT
		*,
	EXTRACT(MONTH FROM order_date) as month,
0


-- Q.20 monthly Restaurant Growth Ration:
-- Calculate each resraurant's growth ratio based on the total number of delivered orders since its joining.