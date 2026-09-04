-- ============================================
-- 01 DATA EXPLORATION
-- E-commerce Business Analytics
-- Database: ecommerce_analytics
-- ============================================
--
-- Purpose:
-- Explore the dataset structure, validate row counts,
-- inspect sample records, identify available dimensions,
-- and perform basic data-quality checks.
-- ============================================


-- 1. Check table row counts
-- Provides an initial overview of the dataset size.

SELECT 'products' AS table_name, COUNT(*) AS row_count
FROM products

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items

UNION ALL

SELECT 'order_item_refunds', COUNT(*)
FROM order_item_refunds

UNION ALL

SELECT 'website_sessions', COUNT(*)
FROM website_sessions

UNION ALL

SELECT 'website_pageviews', COUNT(*)
FROM website_pageviews;


-- 2. Inspect products
-- Review sample records and column structure.

SELECT *
FROM products
LIMIT 10;


-- 3. Inspect orders
-- Review sample order records.

SELECT *
FROM orders
LIMIT 10;


-- 4. Inspect order items
-- Review individual products purchased within orders.

SELECT *
FROM order_items
LIMIT 10;


-- 5. Inspect refunds
-- Review refund transactions and amounts.

SELECT *
FROM order_item_refunds
LIMIT 10;


-- 6. Inspect website sessions
-- Review traffic source, device and session information.

SELECT *
FROM website_sessions
LIMIT 10;


-- 7. Inspect website pageviews
-- Review page-level website activity.

SELECT *
FROM website_pageviews
LIMIT 10;


-- 8. Check the date range of orders
-- Identifies the period covered by the sales data.

SELECT
    MIN(created_at) AS first_order,
    MAX(created_at) AS last_order
FROM orders;


-- 9. Check available website traffic sources
-- Identifies the marketing/source dimensions available for analysis.

SELECT DISTINCT
    utm_source
FROM website_sessions
ORDER BY utm_source;


-- 10. Check available device types
-- Identifies the devices used to access the website.

SELECT DISTINCT
    device_type
FROM website_sessions
ORDER BY device_type;


-- 11. Check the most visited pages
-- Identifies the pages receiving the highest number of pageviews.

SELECT
    pageview_url,
    COUNT(*) AS pageviews
FROM website_pageviews
GROUP BY pageview_url
ORDER BY pageviews DESC
LIMIT 15;


-- 12. Check for NULL values in key order fields
-- Basic data-quality validation before analysis.

SELECT
    COUNT(*) FILTER (WHERE order_id IS NULL) AS null_order_ids,
    COUNT(*) FILTER (WHERE created_at IS NULL) AS null_created_at,
    COUNT(*) FILTER (WHERE user_id IS NULL) AS null_user_ids,
    COUNT(*) FILTER (WHERE price_usd IS NULL) AS null_prices
FROM orders;


-- 13. Check for duplicate order IDs
-- Order IDs should be unique in the orders table.

SELECT
    order_id,
    COUNT(*) AS occurrences
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;