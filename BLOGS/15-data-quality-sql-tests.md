# Data Quality: The SQL Tests That Save You

> **Level:** L4 (Data Engineer) · **Reading time:** 6 minutes

---

## 🎣 The Hook

A single NULL in the wrong place. A duplicate that double-counts revenue. An orphaned foreign key that breaks a join. Bad data doesn't announce itself — it quietly corrupts dashboards and poisons AI models until someone notices the numbers are wrong. The defense? SQL data quality tests.

---

## 💼 The Business Problem

DataVerse's executive dashboard showed revenue 30% higher than reality for two weeks. The cause: duplicate rows from a broken load. Nobody caught it because nothing validated the data. The CDO mandates: *"Every pipeline gets quality gates."*

---

## 🧠 The Concept

Data quality tests are SQL queries that should return **zero rows** (or an expected value). If they don't, the pipeline fails loudly instead of corrupting silently.

### The Five Essential Tests

```sql
-- 1. NOT NULL: critical columns must have values
SELECT COUNT(*) FROM orders WHERE customer_id IS NULL;        -- expect 0

-- 2. UNIQUE: no duplicate keys
SELECT customer_id, COUNT(*) FROM customers
GROUP BY customer_id HAVING COUNT(*) > 1;                     -- expect no rows

-- 3. REFERENTIAL INTEGRITY: no orphaned foreign keys
SELECT o.order_id FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;                                  -- expect no rows

-- 4. RANGE: values within valid bounds
SELECT * FROM employees WHERE salary < 0 OR salary > 1000000; -- expect no rows

-- 5. ACCEPTED VALUES: only allowed categories
SELECT DISTINCT order_status FROM orders
WHERE order_status NOT IN ('Pending','Processing','Shipped','Delivered','Cancelled','Returned');
```

These five map directly to dbt's built-in tests (`not_null`, `unique`, `relationships`, `accepted_values`).

---

## 📊 A Quality Summary in One Query

```sql
SELECT 
    'orders' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customers,
    COUNT(DISTINCT order_id) AS unique_ids,
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_ids
FROM orders;
```

Run this after every load and you'll catch problems before they reach a dashboard.

---

## 🔬 Freshness & Volume Checks

```sql
-- Freshness: is the data recent?
SELECT MAX(order_date) AS latest, CURRENT_DATE - MAX(order_date) AS days_stale
FROM orders;

-- Volume anomaly: did row counts suddenly drop?
SELECT COUNT(*) FROM orders WHERE order_date = CURRENT_DATE;
```

---

## 🏋️ Try It Yourself

1. Write the five essential tests for the `employees` table.
2. Build a one-query quality summary for `customers`.
3. Add a freshness check that flags data older than 1 day.

→ Practice in [MISSION 12](../MISSIONS/MISSION-12/README.md).

---

## 🔗 References

- [Mission 12: Data Engineering Pipelines](../MISSIONS/MISSION-12/README.md)

---

## 📣 LinkedIn Summary

> Bad data doesn't announce itself. A NULL, a duplicate, an orphaned key — it quietly corrupts dashboards and poisons AI models until someone notices the numbers are wrong. The fix is simple SQL tests that fail loudly. Here are the 5 every pipeline needs. 👇

**SEO keywords:** data quality, SQL tests, dbt tests, data validation, referential integrity, data engineering, data observability, pipeline testing
