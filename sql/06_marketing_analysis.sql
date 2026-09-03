-- ============================================
-- 06 MARKETING CHANNEL ANALYSIS
-- E-commerce Business Analytics
-- ============================================


-- 1. Sessions by marketing channel

SELECT
    COALESCE(utm_source, 'Direct / Unknown') AS channel,
    COUNT(*) AS sessions
FROM website_sessions
GROUP BY COALESCE(utm_source, 'Direct / Unknown')
ORDER BY sessions DESC;


-- 2. Sessions, orders and conversion by channel

SELECT
    COALESCE(ws.utm_source, 'Direct / Unknown') AS channel,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        COUNT(DISTINCT o.order_id) * 100.0
        / NULLIF(COUNT(DISTINCT ws.website_session_id), 0),
        2
    ) AS conversion_rate_pct
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY COALESCE(ws.utm_source, 'Direct / Unknown')
ORDER BY conversion_rate_pct DESC;


-- 3. Revenue by marketing channel

SELECT
    COALESCE(ws.utm_source, 'Direct / Unknown') AS channel,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(o.price_usd), 2) AS revenue
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY COALESCE(ws.utm_source, 'Direct / Unknown')
ORDER BY revenue DESC;


-- 4. Average order value by marketing channel

SELECT
    COALESCE(ws.utm_source, 'Direct / Unknown') AS channel,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        SUM(o.price_usd)
        / NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY COALESCE(ws.utm_source, 'Direct / Unknown')
ORDER BY average_order_value DESC;


-- 5. Marketing channel performance by year

SELECT
    EXTRACT(YEAR FROM ws.created_at) AS year,
    COALESCE(ws.utm_source, 'Direct / Unknown') AS channel,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        COUNT(DISTINCT o.order_id) * 100.0
        / NULLIF(COUNT(DISTINCT ws.website_session_id), 0),
        2
    ) AS conversion_rate_pct,
    ROUND(SUM(o.price_usd), 2) AS revenue
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY
    EXTRACT(YEAR FROM ws.created_at),
    COALESCE(ws.utm_source, 'Direct / Unknown')
ORDER BY year, revenue DESC;