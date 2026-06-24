# ❄️ Snowflake SQL Mapping Cheat Sheet

> Your PostgreSQL skills transfer to Snowflake. Here's what's the same and what's different.

---

## The Big Picture

Snowflake uses **ANSI SQL** — SELECT, JOIN, GROUP BY, window functions, CTEs all work identically. Differences are in DDL, performance (automatic in Snowflake), and cloud-native features.

---

## Type Mapping

| PostgreSQL | Snowflake | Note |
|------------|-----------|------|
| `SERIAL` | `AUTOINCREMENT` / `IDENTITY` | auto-increment |
| `INTEGER`, `BIGINT` | `INTEGER`, `NUMBER` | |
| `NUMERIC(p,s)` | `NUMBER(p,s)` | |
| `REAL`, `DOUBLE PRECISION` | `FLOAT` | |
| `VARCHAR(n)`, `TEXT` | `VARCHAR`, `STRING` | no length penalty |
| `BOOLEAN` | `BOOLEAN` | same |
| `TIMESTAMP` | `TIMESTAMP_NTZ` | |
| `TIMESTAMPTZ` | `TIMESTAMP_TZ` | |
| `JSONB` | `VARIANT` | semi-structured |
| `UUID` | `STRING` | |
| `ARRAY` | `ARRAY` | |

## DDL Differences

```sql
-- PostgreSQL
CREATE TABLE t (id SERIAL PRIMARY KEY, name TEXT);
CREATE INDEX idx ON t(name);

-- Snowflake
CREATE TABLE t (id INTEGER AUTOINCREMENT, name VARCHAR);
-- No CREATE INDEX needed — automatic micro-partitions
ALTER TABLE t CLUSTER BY (name);   -- optional clustering for huge tables
```

## What's the SAME (no changes needed)

```sql
-- All of these work identically in both:
SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY, LIMIT
INNER/LEFT/RIGHT/FULL/CROSS JOIN
CTEs (WITH ...), recursive CTEs
Window functions (ROW_NUMBER, RANK, LAG, LEAD, SUM OVER ...)
CASE WHEN, COALESCE, NULLIF
UNION, INTERSECT, EXCEPT
ILIKE, string concatenation
```

## Function Mapping

| PostgreSQL | Snowflake |
|------------|-----------|
| `NOW()` | `CURRENT_TIMESTAMP()` |
| `CURRENT_DATE` | `CURRENT_DATE()` |
| `string \|\| string` | `\|\|` or `CONCAT()` |
| `DATE_TRUNC('month', d)` | `DATE_TRUNC('month', d)` (same) |
| `EXTRACT(YEAR FROM d)` | `YEAR(d)` or `EXTRACT` |
| `generate_series(1,10)` | `TABLE(GENERATOR(ROWCOUNT=>10))` |
| `data->>'key'` | `data:key::string` |
| `STRING_AGG(x, ',')` | `LISTAGG(x, ',')` |
| `::type` cast | `::type` (same) |

---

## Snowflake-Only Features

### Virtual Warehouses (compute)

```sql
CREATE WAREHOUSE etl_wh WAREHOUSE_SIZE='LARGE' AUTO_SUSPEND=60 AUTO_RESUME=TRUE;
ALTER WAREHOUSE etl_wh SET WAREHOUSE_SIZE='XLARGE';
USE WAREHOUSE etl_wh;
```

### Time Travel

```sql
SELECT * FROM t AT (OFFSET => -3600);            -- 1 hour ago
SELECT * FROM t BEFORE (STATEMENT => '<id>');
UNDROP TABLE t;
```

### Zero-Copy Cloning

```sql
CREATE TABLE t_dev CLONE t;
CREATE DATABASE dev CLONE prod;
```

### Streams (CDC)

```sql
CREATE STREAM s ON TABLE raw;
SELECT * FROM s WHERE METADATA$ACTION = 'INSERT';
```

### Tasks (scheduling)

```sql
CREATE TASK my_task WAREHOUSE=etl_wh SCHEDULE='60 MINUTE'
AS INSERT INTO target SELECT * FROM source_stream;
ALTER TASK my_task RESUME;
```

### Dynamic Tables (auto-refresh)

```sql
CREATE DYNAMIC TABLE dt TARGET_LAG='1 hour' WAREHOUSE=etl_wh
AS SELECT date, SUM(revenue) FROM fact GROUP BY date;
```

### Loading Data

```sql
CREATE STAGE my_stage;
COPY INTO t FROM @my_stage/file.parquet FILE_FORMAT=(TYPE=PARQUET);
```

### Semi-Structured (VARIANT)

```sql
SELECT data:customer:name::string FROM events;
SELECT value FROM t, LATERAL FLATTEN(input => t.json_array);
```

---

## 🧠 What You DON'T Do in Snowflake

| PostgreSQL task | Snowflake |
|-----------------|-----------|
| `CREATE INDEX` | automatic (micro-partitions) |
| `VACUUM` / `ANALYZE` | automatic |
| `PARTITION BY` (tables) | `CLUSTER BY` (optional) |
| Manage connection pools | managed |
| Tune memory/buffers | managed |

---

## 💡 Migration Tip

90% of your SQL moves unchanged. Focus your migration effort on:
1. **DDL** (types, no indexes)
2. **Data loading** (stages + COPY INTO)
3. **Pipelines** (Streams + Tasks instead of cron)
4. **Cost control** (auto-suspend warehouses)
