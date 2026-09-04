-- ============================================
-- 07 REFUNDS & PROFITABILITY ANALYSIS
-- E-commerce Business Analytics
-- Database: ecommerce_analytics
-- ============================================
--
-- Purpose:
-- Analyze refund activity, net revenue, product
-- profitability, and product-level refund rates.
--
-- Refunds are aggregated at the order-item level
-- before being joined to sales data to avoid
-- duplicating revenue or cost values.
-- ============================================


-- 1. Total refunds
-- Measures the number of refund transactions
-- and the total amount refunded.

SELECT
    COUNT(*) AS refund_records,
    ROUND(SUM(refund_amount_usd), 2) AS total_refunded
FROM order_item_refunds;


-- 2. Refund rate
-- Measures total refunded value as a percentage
-- of gross order revenue.

SELECT
    ROUND(
        (
            SELECT SUM(refund_amount_usd)
            FROM order_item_refunds
        ) * 100.0
        / NULLIF(
            (
                SELECT SUM(price_usd)
                FROM orders
            ),
            0
        ),
        2
    ) AS refund_rate_pct;


-- 3. Net revenue after refunds
-- Calculates revenue remaining after refunds.

SELECT
    ROUND(
        (SELECT SUM(price_usd) FROM orders),
        2
    ) AS gross_revenue,

    ROUND(
        (SELECT SUM(refund_amount_usd)
         FROM order_item_refunds),
        2
    ) AS total_refunded,

    ROUND(
        (SELECT SUM(price_usd) FROM orders)
        -
        (SELECT SUM(refund_amount_usd)
         FROM order_item_refunds),
        2
    ) AS net_revenue;


-- 4. Product profitability
-- Calculates gross revenue, COGS, refunds,
-- net profit, and net profit margin by product.
--
-- Refunds are aggregated by order item first
-- to prevent duplicated sales values.

WITH refunds_by_item AS (
    SELECT
        order_item_id,
        SUM(refund_amount_usd) AS refund_amount
    FROM order_item_refunds
    GROUP BY order_item_id
)

SELECT
    p.product_name,

    ROUND(
        SUM(oi.price_usd),
        2
    ) AS gross_revenue,

    ROUND(
        SUM(oi.cogs_usd),
        2
    ) AS cogs,

    ROUND(
        COALESCE(SUM(r.refund_amount), 0),
        2
    ) AS refunds,

    ROUND(
        SUM(oi.price_usd)
        - SUM(oi.cogs_usd)
        - COALESCE(SUM(r.refund_amount), 0),
        2
    ) AS net_profit,

    ROUND(
        (
            SUM(oi.price_usd)
            - SUM(oi.cogs_usd)
            - COALESCE(SUM(r.refund_amount), 0)
        ) * 100.0
        / NULLIF(SUM(oi.price_usd), 0),
        2
    ) AS net_margin_pct

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN refunds_by_item r
    ON oi.order_item_id = r.order_item_id

GROUP BY p.product_name

ORDER BY net_profit DESC;


-- 5. Refund rate by product
-- Identifies products with the highest proportion
-- of revenue returned by customers.

WITH refunds_by_item AS (
    SELECT
        order_item_id,
        SUM(refund_amount_usd) AS refund_amount
    FROM order_item_refunds
    GROUP BY order_item_id
)

SELECT
    p.product_name,

    ROUND(
        SUM(oi.price_usd),
        2
    ) AS gross_revenue,

    ROUND(
        COALESCE(SUM(r.refund_amount), 0),
        2
    ) AS refunds,

    ROUND(
        COALESCE(SUM(r.refund_amount), 0) * 100.0
        / NULLIF(SUM(oi.price_usd), 0),
        2
    ) AS refund_rate_pct

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN refunds_by_item r
    ON oi.order_item_id = r.order_item_id

GROUP BY p.product_name

ORDER BY refund_rate_pct DESC;