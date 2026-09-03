-- ============================================
-- 04 WEBSITE ANALYSIS
-- E-commerce Business Analytics
-- ============================================


-- 1. Website sessions by month
SELECT
    DATE_TRUNC('month', created_at) AS month,
    COUNT(*) AS sessions
FROM website_sessions
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY month;


-- 2. Sessions and orders by device
SELECT
    ws.device_type,
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
GROUP BY ws.device_type
ORDER BY conversion_rate_pct DESC;


-- 3. Most visited pages
SELECT
    pageview_url,
    COUNT(*) AS pageviews
FROM website_pageviews
GROUP BY pageview_url
ORDER BY pageviews DESC
LIMIT 15;


-- 4. Website sessions by marketing source
SELECT
    COALESCE(utm_source, 'Direct / Unknown') AS channel,
    COUNT(*) AS sessions
FROM website_sessions
GROUP BY COALESCE(utm_source, 'Direct / Unknown')
ORDER BY sessions DESC;


-- 5. Marketing channel conversion
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