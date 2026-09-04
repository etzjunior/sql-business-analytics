-- ============================================
-- 03 CUSTOMER ANALYSIS
-- E-commerce Business Analytics
-- Database: ecommerce_analytics
-- ============================================
--
-- Purpose:
-- Analyze customer acquisition, order frequency,
-- repeat purchasing behavior, and customer segments.
-- ============================================


-- 1. Unique customers by year
-- Measures the number of distinct customers placing orders each year.

SELECT
    EXTRACT(YEAR FROM created_at) AS year,
    COUNT(DISTINCT user_id) AS unique_customers
FROM orders
GROUP BY EXTRACT(YEAR FROM created_at)
ORDER BY year;


-- 2. Orders per customer
-- Identifies customers with the highest number of orders.

SELECT
    user_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY user_id
ORDER BY order_count DESC
LIMIT 20;


-- 3. Identify repeat customers
-- Identifies customers who placed more than one order.

SELECT
    user_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY user_id
HAVING COUNT(*) > 1
ORDER BY order_count DESC;


-- 4. Repeat customer KPI
-- Calculates the number and percentage of customers
-- who placed more than one order.

SELECT
    COUNT(*) AS repeat_customers,
    (SELECT COUNT(DISTINCT user_id) FROM orders) AS total_customers,
    ROUND(
        COUNT(*) * 100.0
        / (SELECT COUNT(DISTINCT user_id) FROM orders),
        2
    ) AS repeat_customer_rate_pct
FROM (
    SELECT
        user_id
    FROM orders
    GROUP BY user_id
    HAVING COUNT(*) > 1
) AS repeat_users;


-- 5. Average and maximum orders among repeat customers
-- Measures purchasing frequency among customers who
-- have already placed multiple orders.

SELECT
    ROUND(AVG(order_count), 2) AS avg_orders_per_repeat_customer,
    MAX(order_count) AS max_orders_by_customer
FROM (
    SELECT
        user_id,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY user_id
    HAVING COUNT(*) > 1
) AS customer_orders;


-- 6. Customer order-frequency segments
-- Groups customers according to the number of orders placed.

WITH customer_orders AS (
    SELECT
        user_id,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY user_id
)
SELECT
    CASE
        WHEN order_count = 1 THEN '1 order'
        WHEN order_count BETWEEN 2 AND 3 THEN '2-3 orders'
        WHEN order_count BETWEEN 4 AND 5 THEN '4-5 orders'
        ELSE '6+ orders'
    END AS customer_segment,
    COUNT(*) AS customers
FROM customer_orders
GROUP BY
    CASE
        WHEN order_count = 1 THEN '1 order'
        WHEN order_count BETWEEN 2 AND 3 THEN '2-3 orders'
        WHEN order_count BETWEEN 4 AND 5 THEN '4-5 orders'
        ELSE '6+ orders'
    END
ORDER BY customers DESC;