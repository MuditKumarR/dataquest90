# ✅ Mission 10 — Solutions

Worked solutions for [Mission 10](../MISSIONS/MISSION-10/README.md). Try first!

---

### 1. Facts vs dimensions

| Column | Type |
|--------|------|
| `revenue` | Fact (measure) |
| `customer_name` | Dimension |
| `quantity` | Fact (measure) |
| `product_category` | Dimension |
| `order_date` | Dimension (date) |
| `gross_profit` | Fact (measure) |

### 2. Build and populate dim_date for 2024

```sql
CREATE TABLE dim_date (
    date_key      INT PRIMARY KEY,
    full_date     DATE NOT NULL,
    year          INT, quarter INT, month INT, day INT,
    month_name    TEXT, weekday_name TEXT, is_weekend BOOLEAN
);

INSERT INTO dim_date
SELECT TO_CHAR(d, 'YYYYMMDD')::INT,
       d,
       EXTRACT(YEAR FROM d), EXTRACT(QUARTER FROM d),
       EXTRACT(MONTH FROM d), EXTRACT(DAY FROM d),
       TO_CHAR(d, 'Month'), TO_CHAR(d, 'Day'),
       EXTRACT(ISODOW FROM d) IN (6, 7)
FROM generate_series('2024-01-01'::date, '2024-12-31'::date, '1 day') AS d;
```

### 3. Build fact_sales from sales_transactions

```sql
CREATE TABLE fact_sales (
    sale_key       BIGSERIAL PRIMARY KEY,
    date_key       INT REFERENCES dim_date(date_key),
    customer_key   INT,
    product_key    INT,
    employee_key   INT,
    quantity       INT,
    revenue        NUMERIC(12,2),
    gross_profit   NUMERIC(12,2)
);

INSERT INTO fact_sales (date_key, customer_key, product_key, employee_key, quantity, revenue, gross_profit)
SELECT TO_CHAR(s.sale_date, 'YYYYMMDD')::INT,
       o.customer_id, s.product_id, s.sales_rep_id,
       s.quantity, s.revenue, s.gross_profit
FROM sales_transactions s
LEFT JOIN orders o ON s.order_id = o.order_id;
```

### 4. Star-schema query: revenue by industry and quarter

```sql
SELECT c.industry, dd.quarter, SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_date dd ON f.date_key = dd.date_key
JOIN customers c ON f.customer_key = c.customer_id
GROUP BY c.industry, dd.quarter
ORDER BY c.industry, dd.quarter;
```

### 5. SCD Type 1 — overwrite a product category

```sql
UPDATE dim_product
SET category = 'Cloud Software'
WHERE product_code = 'PRD-0007';
```

### 6. SCD Type 2 — employee relocates Austin → Dallas

```sql
-- Close the current row
UPDATE dim_employee
SET valid_to = CURRENT_DATE, is_current = FALSE
WHERE employee_id = 42 AND is_current = TRUE;

-- Insert the new current row
INSERT INTO dim_employee (employee_id, full_name, location, valid_from, valid_to, is_current)
VALUES (42, 'Sarah Mitchell', 'Dallas', CURRENT_DATE, NULL, TRUE);
```

### 7. Point-in-time query

```sql
SELECT employee_id, location
FROM dim_employee
WHERE employee_id = 42
  AND '2024-03-15' >= valid_from
  AND ('2024-03-15' < valid_to OR valid_to IS NULL);
```

### 8. Junk dimension (DDL only)

```sql
CREATE TABLE dim_order_flags (
    flag_key        SERIAL PRIMARY KEY,
    payment_status  VARCHAR(20),
    shipping_method VARCHAR(20)
);
-- One row per unique combination, referenced by fact_sales.flag_key.
```

---

## 🔥 Challenge — Full star schema with SCD2

Build `dim_customer` (SCD2 with valid_from/valid_to/is_current), `dim_product`, `dim_employee`, `dim_date`, and `fact_sales`. Load from operational tables (see #2–#3 above), then:

```sql
-- Revenue by customer tier AS IT WAS at sale time
SELECT dc.contract_tier, SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_date dd ON f.date_key = dd.date_key
JOIN dim_customer dc
  ON f.customer_key = dc.customer_id
 AND dd.full_date >= dc.valid_from
 AND (dd.full_date < dc.valid_to OR dc.valid_to IS NULL)
GROUP BY dc.contract_tier
ORDER BY revenue DESC;
```

→ Next: [Mission 11 Solutions](MISSION-11.md) · See [Warehouse Architecture diagram](../DIAGRAMS/data-warehouse-architecture.md)
