-- ============================================
-- 02 SALES ANALYSIS
-- E-commerce Business Analytics
-- Database: ecommerce_analytics
-- ============================================
--
-- Purpose:
-- Analyze revenue, order volume, average order value,
-- product performance, profit, and profit margins.
-- ============================================


-- 1. Revenue by year
-- Measures total revenue generated each year.

SELECT
    EXTRACT(YEAR FROM created_at) AS year,
    ROUND(SUM(price_usd), 2) AS revenue
FROM orders
GROUP BY EXTRACT(YEAR FROM created_at)
ORDER BY year;


-- 2. Orders by year
-- Measures the number of orders placed each year.

SELECT
    EXTRACT(YEAR FROM created_at) AS year,
    COUNT(*) AS orders
FROM orders
GROUP BY EXTRACT(YEAR FROM created_at)
ORDER BY year;


-- 3. Average Order Value (AOV) by year
-- Measures the average amount spent per order.

SELECT
    EXTRACT(YEAR FROM created_at) AS year,
    ROUND(AVG(price_usd), 2) AS average_order_value
FROM orders
GROUP BY EXTRACT(YEAR FROM created_at)
ORDER BY year;


-- 4. Year-over-year revenue growth
-- Measures how revenue changed compared with the previous year.

WITH yearly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM created_at) AS year,
        SUM(price_usd) AS revenue
    FROM orders
    GROUP BY EXTRACT(YEAR FROM created_at)
)
SELECT
    year,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year))
        * 100.0
        / NULLIF(LAG(revenue) OVER (ORDER BY year), 0),
        2
    ) AS revenue_growth_pct
FROM yearly_revenue
ORDER BY year;


-- 5. Revenue by product
-- Identifies which products generate the most revenue.

SELECT
    p.product_name,
    ROUND(SUM(oi.price_usd), 2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;


-- 6. Profit by product
-- Calculates profit before refunds using revenue minus COGS.

SELECT
    p.product_name,
    ROUND(SUM(oi.price_usd - oi.cogs_usd), 2) AS profit
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY profit DESC;


-- 7. Profit margin by product
-- Measures profitability relative to product revenue.

SELECT
    p.product_name,
    ROUND(
        SUM(oi.price_usd - oi.cogs_usd) * 100.0
        / NULLIF(SUM(oi.price_usd), 0),
        2
    ) AS profit_margin_pct
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY profit_margin_pct DESC;