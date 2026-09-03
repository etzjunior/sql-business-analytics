-- ============================================
-- 02 SALES ANALYSIS
-- E-commerce Business Analytics
-- ============================================


-- 1. Revenue by year
SELECT
    EXTRACT(YEAR FROM created_at) AS year,
    ROUND(SUM(price_usd), 2) AS revenue
FROM orders
GROUP BY EXTRACT(YEAR FROM created_at)
ORDER BY year;


-- 2. Orders by year
SELECT
    EXTRACT(YEAR FROM created_at) AS year,
    COUNT(*) AS orders
FROM orders
GROUP BY EXTRACT(YEAR FROM created_at)
ORDER BY year;


-- 3. Average Order Value (AOV) by year
SELECT
    EXTRACT(YEAR FROM created_at) AS year,
    ROUND(AVG(price_usd), 2) AS average_order_value
FROM orders
GROUP BY EXTRACT(YEAR FROM created_at)
ORDER BY year;


-- 4. Revenue by product
SELECT
    p.product_name,
    ROUND(SUM(oi.price_usd), 2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;


-- 5. Profit by product
SELECT
    p.product_name,
    ROUND(SUM(oi.price_usd - oi.cogs_usd), 2) AS profit
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY profit DESC;


-- 6. Profit margin by product
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