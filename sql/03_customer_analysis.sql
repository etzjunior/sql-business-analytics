-- ============================================
-- 03 CUSTOMER ANALYSIS
-- E-commerce Business Analytics
-- ============================================


-- 1. Unique customers by year
SELECT
    EXTRACT(YEAR FROM created_at) AS year,
    COUNT(DISTINCT user_id) AS unique_customers
FROM orders
GROUP BY EXTRACT(YEAR FROM created_at)
ORDER BY year;


-- 2. Orders per customer
SELECT
    user_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY user_id
ORDER BY order_count DESC
LIMIT 20;


-- 3. Identify repeat customers
SELECT
    user_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY user_id
HAVING COUNT(*) > 1
ORDER BY order_count DESC;


-- 4. Repeat customer KPI
SELECT
    COUNT(*) AS repeat_customers,
    (SELECT COUNT(DISTINCT user_id) FROM orders) AS total_customers,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(DISTINCT user_id) FROM orders),
        2
    ) AS repeat_customer_rate_pct
FROM (
    SELECT user_id
    FROM orders
    GROUP BY user_id
    HAVING COUNT(*) > 1
) AS repeat_users;


-- 5. Average and maximum orders among repeat customers
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