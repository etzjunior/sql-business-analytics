# E-Commerce Business Analytics with SQL

## Project Overview

This project analyzes e-commerce sales, customer behavior, website activity, marketing channels, conversion funnels, refunds, and product profitability using SQL and PostgreSQL.

The goal is to transform raw e-commerce data into business insights that can support decisions around sales performance, customer retention, marketing effectiveness, website conversion, and profitability.

## Business Questions

- How has revenue changed over time?
- Which products generate the most revenue and profit?
- Which products have the highest refund rates?
- How effectively does the website convert visitors into customers?
- How does conversion differ between desktop and mobile users?
- Which marketing channels generate the most traffic and orders?
- Where are customers dropping out of the purchase funnel?
- How strong is customer repeat-purchase behavior?
- What is the impact of refunds on revenue and profitability?

## Dataset

The project uses the Maven Fuzzy Factory e-commerce dataset.

The dataset contains:

- Products
- Orders
- Order items
- Refunds
- Website sessions
- Website pageviews

The raw dataset is stored locally and excluded from the GitHub repository.

## Tools & Technologies

- PostgreSQL
- SQL
- Git
- GitHub
- VS Code

## Database Structure

The database contains six main tables connected through primary and foreign key relationships:

    products
        │
        ↓
    order_items ← order_item_refunds
        ↑
        │
    orders
        │
        ↓
    website_sessions
        │
        ↓
    website_pageviews

The tables represent different levels of detail, so data grain was considered carefully when joining tables to avoid duplicated metrics.

## SQL Analysis

The analysis is organized into seven SQL scripts:

| File | Analysis |
|---|---|
| `01_data_exploration.sql` | Dataset structure and initial exploration |
| `02_sales_analysis.sql` | Revenue, orders and sales performance |
| `03_customer_analysis.sql` | Customer behavior and repeat purchases |
| `04_website_analysis.sql` | Website traffic and device performance |
| `05_funnel_analysis.sql` | Website conversion funnel |
| `06_marketing_analysis.sql` | Marketing channel performance |
| `07_refunds_profitability.sql` | Refunds, profitability and product margins |

## Key SQL Skills Demonstrated

- Data exploration and validation
- Aggregations using `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX`
- `GROUP BY` and `HAVING`
- `INNER JOIN` and `LEFT JOIN`
- `COUNT(DISTINCT ...)`
- `CASE` statements
- Subqueries
- Common Table Expressions (CTEs)
- Window functions such as `LAG`
- Date-based analysis using `EXTRACT`
- Funnel analysis
- KPI and conversion-rate calculations
- Profitability and margin analysis
- Handling `NULL` values with `COALESCE`
- Preventing metric duplication through careful data-grain management

## Key Findings

### Revenue Performance

2014 was the strongest year in the dataset, generating more than $1 million in revenue.

Average order value increased from $49.99 in 2012 to $63.80 in 2014, indicating that customers were spending more per order.

### Product Profitability

The Original Mr. Fuzzy generated the highest net profit at approximately $677K.

However, the Hudson River Mini Bear achieved the highest net profit margin at 67.08%.

This shows that the product generating the most revenue or profit is not necessarily the most efficient in terms of profitability.

### Refunds

The business recorded 1,731 refund transactions totaling $85,338.69.

The overall refund rate was 4.40%.

The Birthday Sugar Panda had the highest refund rate at 6.04%, while the Hudson River Mini Bear had the lowest at 1.28%.

### Customer Retention

The dataset contains 31,696 customers, of which 591 placed more than one order.

This results in a repeat-customer rate of 1.86%.

The low repeat-customer rate suggests a potential opportunity to investigate customer retention and repeat-purchase strategies.

### Device Performance

Desktop conversion was 8.50%, compared with 3.09% on mobile.

Desktop therefore converted at approximately 2.75 times the mobile rate.

This suggests that the mobile purchasing experience could be investigated for potential conversion barriers.

### Website Conversion Funnel

The largest drop-off occurred between the product page and cart.

- Products → Cart: 36.35%
- Cart → Shipping: 67.91%
- Shipping → Billing: 75.12%
- Billing → Purchase: 66.71%
- Product → Purchase: 12.37%

This makes the product-to-cart stage a key area for further investigation.

### Marketing Channel Performance

gsearch generated the highest traffic, orders, and revenue.

However, Direct / Unknown and bsearch achieved higher conversion rates than gsearch.

socialbook had the lowest conversion rate at 3.21%.

This shows why marketing performance should be evaluated using both traffic volume and conversion efficiency.

## Business Recommendations

### 1. Investigate Mobile Conversion

Review the mobile product, cart, shipping, and checkout experience to identify potential conversion barriers.

### 2. Improve Product-to-Cart Conversion

The largest funnel drop-off occurs between product pages and the cart, with only 36.35% of product-stage sessions reaching the cart.

The business could investigate product-page design, pricing presentation, product information, calls to action, and mobile usability.

### 3. Investigate Product Refunds

The Birthday Sugar Panda has the highest refund rate at 6.04%.

Investigating refund reasons and customer feedback could help identify potential product or customer-experience issues.

### 4. Explore Customer Retention

With only 1.86% of customers placing multiple orders, customer retention represents a potential growth opportunity.

Customer segmentation and post-purchase engagement strategies could be investigated to encourage repeat purchases.

### 5. Evaluate Marketing Efficiency

gsearch generates the most revenue and orders, but other channels achieve higher conversion rates.

Marketing decisions should therefore consider traffic volume, conversion rate, and revenue together when evaluating channel performance.

### 6. Balance Revenue and Profitability

The Original Mr. Fuzzy generates the most total profit, while the Hudson River Mini Bear has the highest profit margin.

Product decisions should therefore consider both sales volume and profitability rather than revenue alone.

## Data Quality & SQL Considerations

A key consideration during the analysis was data grain.

For example, `orders` contains one row per order, while `order_item_refunds` can contain multiple refund records for an order item.

Refunds were therefore aggregated to the order-item level before being joined with sales data. This prevents revenue and cost values from being accidentally duplicated.

The analysis also uses `COUNT(DISTINCT ...)` where appropriate when measuring sessions, customers, and orders across joined datasets.

## Project Documentation

- [Data Dictionary](docs/data_dictionary.md)
- [Business Findings](docs/findings.md)

## Project Structure

    sql-business-analytics/
    │
    ├── sql/
    │   ├── 01_data_exploration.sql
    │   ├── 02_sales_analysis.sql
    │   ├── 03_customer_analysis.sql
    │   ├── 04_website_analysis.sql
    │   ├── 05_funnel_analysis.sql
    │   ├── 06_marketing_analysis.sql
    │   └── 07_refunds_profitability.sql
    │
    ├── docs/
    │   ├── data_dictionary.md
    │   └── findings.md
    │
    ├── README.md
    └── .gitignore

## Author

Victor Woha

BSc Computer Science