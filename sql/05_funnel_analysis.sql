-- ============================================
-- 05 PURCHASE FUNNEL ANALYSIS
-- E-commerce Business Analytics
-- ============================================


-- 1. Count unique sessions reaching each
--    stage of the purchase funnel

WITH funnel AS (
    SELECT
        website_session_id,

        MAX(
            CASE
                WHEN pageview_url = '/products'
                THEN 1 ELSE 0
            END
        ) AS viewed_products,

        MAX(
            CASE
                WHEN pageview_url = '/cart'
                THEN 1 ELSE 0
            END
        ) AS viewed_cart,

        MAX(
            CASE
                WHEN pageview_url = '/shipping'
                THEN 1 ELSE 0
            END
        ) AS viewed_shipping,

        MAX(
            CASE
                WHEN pageview_url = '/billing-2'
                THEN 1 ELSE 0
            END
        ) AS viewed_billing,

        MAX(
            CASE
                WHEN pageview_url = '/thank-you-for-your-order'
                THEN 1 ELSE 0
            END
        ) AS completed_order

    FROM website_pageviews
    GROUP BY website_session_id
)

SELECT
    COUNT(*) AS total_sessions,
    SUM(viewed_products) AS product_sessions,
    SUM(viewed_cart) AS cart_sessions,
    SUM(viewed_shipping) AS shipping_sessions,
    SUM(viewed_billing) AS billing_sessions,
    SUM(completed_order) AS completed_orders
FROM funnel;


-- 2. Calculate conversion between funnel stages

WITH funnel AS (
    SELECT
        website_session_id,

        MAX(CASE
            WHEN pageview_url = '/products'
            THEN 1 ELSE 0
        END) AS viewed_products,

        MAX(CASE
            WHEN pageview_url = '/cart'
            THEN 1 ELSE 0
        END) AS viewed_cart,

        MAX(CASE
            WHEN pageview_url = '/shipping'
            THEN 1 ELSE 0
        END) AS viewed_shipping,

        MAX(CASE
            WHEN pageview_url = '/billing-2'
            THEN 1 ELSE 0
        END) AS viewed_billing,

        MAX(CASE
            WHEN pageview_url = '/thank-you-for-your-order'
            THEN 1 ELSE 0
        END) AS completed_order

    FROM website_pageviews
    GROUP BY website_session_id
),

counts AS (
    SELECT
        SUM(viewed_products) AS products,
        SUM(viewed_cart) AS cart,
        SUM(viewed_shipping) AS shipping,
        SUM(viewed_billing) AS billing,
        SUM(completed_order) AS completed
    FROM funnel
)

SELECT
    products,
    cart,
    shipping,
    billing,
    completed,

    ROUND(
        cart * 100.0 / NULLIF(products, 0),
        2
    ) AS products_to_cart_pct,

    ROUND(
        shipping * 100.0 / NULLIF(cart, 0),
        2
    ) AS cart_to_shipping_pct,

    ROUND(
        billing * 100.0 / NULLIF(shipping, 0),
        2
    ) AS shipping_to_billing_pct,

    ROUND(
        completed * 100.0 / NULLIF(billing, 0),
        2
    ) AS billing_to_purchase_pct,

    ROUND(
        completed * 100.0 / NULLIF(products, 0),
        2
    ) AS overall_conversion_pct

FROM counts;