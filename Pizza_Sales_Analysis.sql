CREATE DATABASE PIZZA_SALES_ANALYSIS;

USE PIZZA_SALES_ANALYSIS;

-- ================================================================================================================================
-- Basic Queries
-- ================================================================================================================================

-- 1. Total number of orders placed

SELECT
	COUNT(Order_id) AS Total_Orders
FROM
	Orders;


-- 2. Total revenue generated from pizza sales

SELECT
	ROUND(SUM(o_d.quantity * p.price),1) AS Total_Revenue
FROM
	order_details as o_d JOIN
	pizzas as p ON o_d.pizza_id = p.pizza_id;

-- 3. Top 5 Highest-priced pizza

SELECT TOP 5
	p.pizza_type_id,
	p_t.name,
	p.price
FROM
	pizzas p JOIN
	pizza_types p_t ON p.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC;


-- 4. Most common pizza size ordered

SELECT TOP 1
	P.size,
	SUM(O_D.QUANTITY) AS Total_Quantity
FROM
	pizzas P JOIN
	order_details O_D ON P.pizza_id = O_D.pizza_id
GROUP BY P.size
ORDER BY Total_Quantity DESC;


-- 5. Top 5 most ordered pizza types with quantities

SELECT TOP 5
	P_T.name,
	SUM(O_T.quantity) AS Total_Quantity
FROM
	order_details O_T JOIN
	pizzas P ON O_T.pizza_id = P.pizza_id JOIN
	pizza_types P_T ON P.pizza_type_id = P_T.pizza_type_id
GROUP BY P_T.name
ORDER BY Total_Quantity DESC;


-- ================================================================================================================================
-- Intermediate Queries
-- ================================================================================================================================

-- 6. Total quantity of each pizza category ordered

SELECT
	P_T.category,
	SUM(O_D.quantity) AS Total_Quantity
FROM
	pizza_types P_T JOIN
	pizzas P ON P_T.pizza_type_id = P.pizza_type_id JOIN
	order_details O_D ON P.pizza_id = O_D.pizza_id
GROUP BY P_T.category
ORDER BY Total_Quantity DESC;


-- 7. Distribution of orders by hour of the day

SELECT
	DATEPART(HOUR,[Order_time]) AS Order_Hour,
	COUNT(O_D.order_id) AS Order_Count
FROM
	Orders O JOIN
	order_details O_D ON O.Order_id = O_D.order_id
GROUP BY DATEPART(HOUR,[Order_time])
ORDER BY Order_Hour;

-- 8. Category-wise distribution of pizzas
-- a) Numbers of pizza type in each category

SELECT
	category,
	COUNT(NAME) AS Counts_of_PTypes
FROM
	pizza_types
GROUP BY category
ORDER BY Counts_of_PTypes DESC;

-- b) Share of total pizzas sold by category(percentage)

SELECT
	P_T.category,
	SUM(O_D.QUANTITY) AS Total_Quantity,
	CAST(SUM(O_D.QUANTITY)*100/SUM(SUM(O_D.QUANTITY)) OVER () AS DECIMAL(5,0)) AS Total_Share
FROM
	order_details O_D JOIN
	pizzas P ON O_D.pizza_id = P.pizza_id JOIN
	pizza_types P_T ON P.pizza_type_id = P_T.pizza_type_id
GROUP BY P_T.category
ORDER BY Total_Quantity DESC;

-- 9) Average no. of pizzas ordered per day

SELECT
	CAST(AVG(DAILY_QUANTITY) AS DECIMAL(5,0)) AS Avg_Pizzas_A_Day
FROM
	(SELECT
		O.Order_date,
		SUM(O_D.QUANTITY) AS Daily_Quantity
	FROM
		order_details O_D JOIN
		Orders O ON O_D.order_id = O.Order_id
	GROUP BY O.Order_date) AS daily_orders;

-- 10) Top 3 most ordered pizza types based on revenue

SELECT TOP 3
	P_T.name,
	ROUND(SUM(O_D.QUANTITY*P.PRICE),2) AS Revenue
FROM
	pizzas P JOIN
	pizza_types P_T ON P.pizza_type_id = P_T.pizza_type_id JOIN
	order_details O_D ON P.pizza_id = O_D.pizza_id
GROUP BY P_T.name
ORDER BY Revenue DESC;

-- ================================================================================================================================
-- Advanced Queries
-- ================================================================================================================================

-- 11) Percentage contribution of each pizza type to total revenue
SELECT
	P_T.name,
	ROUND(SUM(O_D.QUANTITY*P.PRICE),2) AS Revenue,
	CAST(SUM(O_D.QUANTITY*P.PRICE)*100/SUM(SUM(O_D.QUANTITY*P.PRICE)) OVER() AS DECIMAL (5,2)) AS P_T_Percentage
FROM
	order_details O_D JOIN
	pizzas P ON O_D.pizza_id = P.pizza_id JOIN
	pizza_types P_T ON P.pizza_type_id = P_T.pizza_type_id
GROUP BY P_T.name
ORDER BY Revenue DESC;

-- 12) Cumulative revenue generated over time
SELECT
	Order_date,
	ROUND(SUM(Daily_Revenue) OVER(ORDER BY ORDER_DATE),2) AS Cumulative_Revenue
FROM (
	SELECT
		O.Order_date,
		ROUND(SUM(O_D.QUANTITY*P.PRICE),2) AS Daily_Revenue
	FROM
		order_details O_D JOIN
		Orders O ON O_D.order_id = O.Order_id JOIN
		pizzas P ON O_D.pizza_id = P.pizza_id
	GROUP BY O.Order_date
	) AS Daily_Revenue
ORDER BY Order_date;

-- 13) Top 3 pizza types by revenue within each pizza category
WITH Category_Revenue AS (
	SELECT
		category,
		name,
		ROUND(SUM(O_D.QUANTITY*P.PRICE),2) AS Revenue
	FROM
		order_details O_D JOIN
		pizzas P ON O_D.pizza_id = P.pizza_id JOIN
		pizza_types P_T ON P.pizza_type_id = P_T.pizza_type_id
	GROUP BY category,name
),
Ranked AS(
	SELECT
		category,
		name,
		Revenue,
		RANK() OVER(PARTITION BY CATEGORY ORDER BY REVENUE DESC) AS Rank_
	FROM
		Category_Revenue
)
SELECT 
	category,
	name,
	Revenue,
	Rank_
FROM
	Ranked
WHERE Rank_ <=3
ORDER BY category,Rank_;


-- ================================================================================================================================
-- END OF THE PIZZA_SALES_ANALYSIS
-- ================================================================================================================================