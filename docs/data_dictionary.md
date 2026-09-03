# Data Dictionary

## Overview

The Maven Fuzzy Factory dataset contains e-commerce data covering website activity, customer sessions, orders, products, and refunds.

The database is structured across six main tables.

---

## Tables

### products

Contains information about the products sold.

| Column | Description |
|---|---|
| product_id | Unique product identifier |
| created_at | Product creation timestamp |
| product_name | Name of the product |

---

### orders

Contains one record for each customer order.

| Column | Description |
|---|---|
| order_id | Unique order identifier |
| created_at | Order creation timestamp |
| website_session_id | Website session associated with the order |
| user_id | Customer identifier |
| primary_product_id | Primary product purchased |
| items_purchased | Number of items in the order |
| price_usd | Order revenue in USD |
| cogs_usd | Cost of goods sold in USD |

---

### order_items

Contains individual products purchased within orders.

| Column | Description |
|---|---|
| order_item_id | Unique order-item identifier |
| created_at | Order-item creation timestamp |
| order_id | Associated order |
| product_id | Product purchased |
| is_primary_item | Indicates whether the item was the primary product |
| price_usd | Item revenue in USD |
| cogs_usd | Item cost in USD |

---

### order_item_refunds

Contains refund transactions associated with order items.

| Column | Description |
|---|---|
| order_item_refund_id | Unique refund identifier |
| created_at | Refund timestamp |
| order_item_id | Associated order item |
| order_id | Associated order |
| refund_amount_usd | Refund amount in USD |

---

### website_sessions

Contains one record for each website session.

| Column | Description |
|---|---|
| website_session_id | Unique session identifier |
| created_at | Session timestamp |
| user_id | Customer identifier |
| is_repeat_session | Indicates whether the session was from a returning customer |
| utm_source | Marketing traffic source |
| utm_campaign | Marketing campaign |
| utm_content | Marketing content |
| device_type | Device used during the session |
| http_referer | Referring URL |

---

### website_pageviews

Contains individual page views generated during website sessions.

| Column | Description |
|---|---|
| website_pageview_id | Unique pageview identifier |
| created_at | Pageview timestamp |
| website_session_id | Associated website session |
| pageview_url | Page visited |

---

## Key Relationships

```text
products
    │
    │ product_id
    ↓
order_items
    │
    │ order_id
    ↓
orders
    │
    │ website_session_id
    ↓
website_sessions
    │
    │ website_session_id
    ↓
website_pageviews

order_items
    │
    │ order_item_id
    ↓
order_item_refunds