-- ============================================
-- 01 DATA EXPLORATION
-- E-commerce Business Analytics
-- Database: ecommerce_analytics
-- ============================================


-- 1. Check table row counts
SELECT 'products' AS table_name, COUNT(*) AS row_count
FROM products

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items

UNION ALL

SELECT 'website_sessions', COUNT(*)
FROM website_sessions

UNION ALL

SELECT 'website_pageviews', COUNT(*)
FROM website_pageviews;


-- 2. Inspect products
SELECT *
FROM products
LIMIT 10;


-- 3. Inspect orders
SELECT *
FROM orders
LIMIT 10;


-- 4. Inspect order items
SELECT *
FROM order_items
LIMIT 10;


-- 5. Inspect website sessions
SELECT *
FROM website_sessions
LIMIT 10;


-- 6. Inspect website pageviews
SELECT *
FROM website_pageviews
LIMIT 10;


-- 7. Check the date range of orders
SELECT
    MIN(created_at) AS first_order,
    MAX(created_at) AS last_order
FROM orders;


-- 8. Check available website traffic sources
SELECT DISTINCT utm_source
FROM website_sessions
ORDER BY utm_source;


-- 9. Check available device types
SELECT DISTINCT device_type
FROM website_sessions
ORDER BY device_type;


-- 10. Check the most visited pages
SELECT
    pageview_url,
    COUNT(*) AS pageviews
FROM website_pageviews
GROUP BY pageview_url
ORDER BY pageviews DESC
LIMIT 15;