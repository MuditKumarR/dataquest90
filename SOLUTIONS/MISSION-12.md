# ✅ Mission 12 — Solutions

Worked solutions for [Mission 12](../MISSIONS/MISSION-12/README.md). Try first!

---

### 1. Silver-layer transformation of customers

```sql
CREATE TABLE silver_customers AS
SELECT customer_id,
       company_name,
       UPPER(TRIM(country)) AS country,
       COALESCE(nps_score, 0) AS nps_score,
       industry, company_size, lifetime_value
FROM bronze_customers
WHERE company_name IS NOT NULL;
```

### 2. Upsert into dim_product

```sql
INSERT INTO dim_product (product_id, product_name, category, unit_price)
SELECT product_id, product_name, category, unit_price
FROM staging_products
ON CONFLICT (product_id)
DO UPDATE SET product_name = EXCLUDED.product_name,
              category     = EXCLUDED.category,
              unit_price   = EXCLUDED.unit_price;
```

### 3. Five data quality checks for orders

```sql
-- (1) Nulls in required column
SELECT COUNT(*) FROM orders WHERE customer_id IS NULL;
-- (2) Duplicate primary keys
SELECT order_id, COUNT(*) FROM orders GROUP BY order_id HAVING COUNT(*) > 1;
-- (3) Referential integrity (orphan customers)
SELECT o.order_id FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
-- (4) Valid range (no negative totals)
SELECT COUNT(*) FROM orders WHERE total_amount < 0;
-- (5) Accepted values
SELECT DISTINCT order_status FROM orders
WHERE order_status NOT IN ('Pending','Processing','Shipped','Delivered','Cancelled','Returned');
```

### 4. Gold-layer monthly revenue per industry

```sql
CREATE TABLE gold_industry_revenue AS
SELECT c.industry,
       DATE_TRUNC('month', o.order_date) AS month,
       COUNT(o.order_id) AS order_count,
       SUM(oi.line_total) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.industry, DATE_TRUNC('month', o.order_date);
```

### 5. Incremental extraction with a watermark

```sql
SELECT *
FROM source_orders
WHERE updated_at > (SELECT MAX(last_loaded_at) FROM etl_watermark WHERE table_name = 'orders');
```

### 6. SQL an Airflow task would run

```sql
INSERT INTO gold_daily_revenue (revenue_date, revenue)
SELECT order_date, SUM(line_total)
FROM silver_orders
WHERE order_date = CURRENT_DATE - 1
GROUP BY order_date
ON CONFLICT (revenue_date) DO UPDATE SET revenue = EXCLUDED.revenue;
```

### 7. One-query data quality summary for employees

```sql
SELECT COUNT(*) AS total_rows,
       COUNT(*) FILTER (WHERE email IS NULL) AS null_emails,
       COUNT(*) - COUNT(DISTINCT employee_id) AS duplicate_ids,
       COUNT(*) FILTER (WHERE salary < 0) AS invalid_salaries
FROM employees;
```

### 8. Batch vs streaming (commentary)

```sql
-- Payroll          → BATCH    : runs on a fixed schedule, accuracy > latency
-- Fraud detection  → STREAMING: must react in milliseconds
-- Daily KPIs       → BATCH    : once-a-day refresh is fine
-- Live dashboards  → STREAMING: users expect near-real-time numbers
```

---

## 🔥 Challenge — Bronze→Silver→Gold ELT pipeline

```sql
-- Bronze: raw landing (load as-is)
CREATE TABLE bronze_sales AS SELECT * FROM source_sales;

-- Silver: clean + conform
CREATE TABLE silver_sales AS
SELECT sale_id, sale_date::date,
       UPPER(TRIM(region)) AS region,
       COALESCE(revenue, 0) AS revenue,
       COALESCE(cost, 0)    AS cost
FROM bronze_sales
WHERE sale_id IS NOT NULL;

-- MERGE-based incremental load into the curated table
INSERT INTO curated_sales
SELECT * FROM silver_sales
ON CONFLICT (sale_id) DO UPDATE
SET revenue = EXCLUDED.revenue, cost = EXCLUDED.cost;

-- Gold: business aggregate
CREATE TABLE gold_region_pnl AS
SELECT region, SUM(revenue) AS revenue, SUM(revenue - cost) AS gross_profit
FROM curated_sales GROUP BY region;

-- Airflow DAG order: extract → load_bronze → build_silver → quality_tests → merge_curated → build_gold
```

→ Next: [Mission 13 Solutions](MISSION-13.md) · See [ETL](../DIAGRAMS/etl-flow.md) & [ELT](../DIAGRAMS/elt-flow.md) diagrams
