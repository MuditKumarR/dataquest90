# ✅ Mission 11 — Solutions

Worked solutions for [Mission 11](../MISSIONS/MISSION-11/README.md). Snowflake syntax. Try first!

---

### 1. Snowflake DDL for fact_sales

```sql
CREATE OR REPLACE TABLE fact_sales (
    sale_key       NUMBER AUTOINCREMENT PRIMARY KEY,
    date_key       NUMBER,
    customer_key   NUMBER,
    product_key    NUMBER,
    employee_key   NUMBER,
    quantity       NUMBER,
    revenue        NUMBER(12,2),
    gross_profit   NUMBER(12,2)
);
-- No CREATE INDEX — Snowflake manages micro-partitions automatically.
```

### 2. Create a SMALL warehouse with auto-suspend

```sql
CREATE WAREHOUSE etl_wh
  WAREHOUSE_SIZE = 'SMALL'
  AUTO_SUSPEND = 120
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;
```

### 3. Time Travel query (30 minutes ago)

```sql
SELECT * FROM dim_customer AT (OFFSET => -60*30);
```

### 4. Zero-Copy Clone

```sql
CREATE TABLE dim_customer_dev CLONE dim_customer;
```

### 5. Create a Stream (CDC)

```sql
CREATE STREAM dim_customer_stream ON TABLE dim_customer;
-- Captures every INSERT/UPDATE/DELETE since the last consumption,
-- exposing METADATA$ACTION and METADATA$ISUPDATE columns.
```

### 6. Scheduled Task

```sql
CREATE TASK refresh_summary
  WAREHOUSE = etl_wh
  SCHEDULE = '30 MINUTE'
AS
  INSERT INTO sales_summary
  SELECT product_key, SUM(revenue) FROM fact_sales GROUP BY product_key;

ALTER TASK refresh_summary RESUME;
```

### 7. Materialized view → Dynamic Table

```sql
CREATE OR REPLACE DYNAMIC TABLE daily_revenue
  TARGET_LAG = '1 hour'
  WAREHOUSE = etl_wh
AS
SELECT date_key, SUM(revenue) AS revenue
FROM fact_sales
GROUP BY date_key;
-- Snowflake refreshes it automatically — no manual REFRESH.
```

### 8. Type mapping

| PostgreSQL | Snowflake |
|------------|-----------|
| `SERIAL` | `NUMBER AUTOINCREMENT` |
| `TEXT` | `VARCHAR` |
| `jsonb` | `VARIANT` |
| `TIMESTAMP` | `TIMESTAMP_NTZ` |

---

## 🔥 Challenge — Migration architecture

```sql
-- (1) Warehouse strategy
CREATE WAREHOUSE etl_wh   WAREHOUSE_SIZE='LARGE'  AUTO_SUSPEND=60;   -- heavy loads
CREATE WAREHOUSE bi_wh    WAREHOUSE_SIZE='MEDIUM' AUTO_SUSPEND=300;  -- dashboards
CREATE WAREHOUSE ds_wh    WAREHOUSE_SIZE='LARGE'  AUTO_SUSPEND=120;  -- data science

-- (2) Streams + Tasks incremental load
CREATE STREAM src_stream ON TABLE staging_sales;
CREATE TASK load_fact
  WAREHOUSE = etl_wh SCHEDULE = '15 MINUTE'
  WHEN SYSTEM$STREAM_HAS_DATA('src_stream')
AS
  MERGE INTO fact_sales t
  USING src_stream s ON t.sale_key = s.sale_key
  WHEN MATCHED THEN UPDATE SET t.revenue = s.revenue
  WHEN NOT MATCHED THEN INSERT (sale_key, revenue) VALUES (s.sale_key, s.revenue);

-- (3) Dev/test/prod via Cloning + Time Travel
CREATE TABLE fact_sales_dev CLONE fact_sales;   -- instant, free
-- Recover from mistakes: SELECT ... AT(OFFSET => -3600);
```

→ Next: [Mission 12 Solutions](MISSION-12.md) · See [Snowflake Architecture diagram](../DIAGRAMS/snowflake-architecture.md)
