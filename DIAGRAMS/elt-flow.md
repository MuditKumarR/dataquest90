# 📊 ELT Flow

**ELT** = Extract → Load → Transform. Load raw data first, then transform *inside* the warehouse with SQL. The modern approach.

---

## The Flow

```mermaid
graph LR
    subgraph "Extract + Load (raw)"
    S1[(Source DB)] --> EL[Fivetran/Airbyte]
    S2[(CRM)] --> EL
    S3[Files/APIs] --> EL
    end
    subgraph "Warehouse (transform with SQL)"
    BRONZE[🥉 Bronze: raw]
    SILVER[🥈 Silver: cleaned]
    GOLD[🥇 Gold: business-ready]
    end
    EL --> BRONZE --> SILVER --> GOLD
    GOLD --> BI[BI / AI]
```

---

## Characteristics

| Aspect | Detail |
|--------|--------|
| Transform location | Inside the warehouse (SQL) |
| Data loaded | Raw, everything |
| Raw data | Always retained (replayable) |
| Born from | Cheap, elastic cloud compute |
| Tools | Fivetran/Airbyte + dbt + Snowflake/BigQuery |

---

## Why ELT Won

```mermaid
graph TD
    A[Load raw first] --> B[Keep all source data]
    B --> C{Requirements change?}
    C -- Yes --> D[Just re-transform with SQL]
    C -- No --> E[Transformations evolve independently]
    D --> F[No re-extraction needed]
```

---

## The Medallion Transform (all SQL)

```sql
-- Silver: clean
CREATE TABLE silver_orders AS
SELECT order_id, UPPER(TRIM(status)) AS status, COALESCE(discount,0) AS discount
FROM bronze_orders WHERE order_date IS NOT NULL;

-- Gold: aggregate
CREATE TABLE gold_daily_revenue AS
SELECT order_date, SUM(revenue) AS revenue
FROM silver_orders GROUP BY order_date;
```

Every transformation is a SQL `SELECT` — version-controlled in dbt.

→ Compare with [ETL Flow](etl-flow.md) · Related: [Mission 12](../MISSIONS/MISSION-12/README.md) · [Medallion blog](../BLOGS/14-medallion-architecture.md)
