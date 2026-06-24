# 🎯 MISSION 09 — Database Performance Crisis

```
┌────────────────────────────────────────────────────────────────────┐
│  LEVEL 5: Senior Data Engineer                                     │
│  XP AVAILABLE: 1000                                               │
│  CONCEPTS: Indexes · EXPLAIN · Query Optimization · Partitioning  │
│            · Statistics · EXPLAIN ANALYZE                          │
│  ESTIMATED TIME: 90 minutes                                       │
└────────────────────────────────────────────────────────────────────┘
```

---

## 📧 The Crisis

> **From:** Marcus Thompson (CTO)
> **To:** You (Senior Data Engineer)
> **Subject:** 🚨 PRODUCTION ALERT — dashboards timing out
>
> *"We have a fire. Our customer-facing analytics dashboard was instant when we had 10,000 rows. Now we have millions and queries take 30+ seconds. Customers are complaining.*
>
> *I need you to understand WHY queries are slow and HOW to make them fast. This is the skill that earns the 'Senior' title.*
>
> *Show me you can read an execution plan, add the right indexes, and optimize our worst queries.*
>
> *— Marcus"*

---

## 🧭 Why This Matters (The Real World)

Anyone can write SQL that *works*. Senior engineers write SQL that works **at scale**.

Performance tuning is what separates a $90K analyst from a $170K senior engineer. When tables grow to millions or billions of rows, the difference between a good and bad query is the difference between 5 milliseconds and 5 minutes.

| Role | How they use performance skills |
|------|----------------------------------|
| **Senior Data Engineer** | Tunes pipelines processing TBs of data |
| **DBA** | Keeps production databases responsive |
| **Architect** | Designs schemas and indexes for scale |
| **Analytics Engineer** | Optimizes dbt model runtimes (and cloud cost) |

---

## 📚 Concept 1 — EXPLAIN (Reading the Plan)

`EXPLAIN` shows **how** PostgreSQL will execute a query — without running it.

```sql
EXPLAIN
SELECT * FROM employees WHERE last_name = 'Smith';
```

Output (simplified):
```
Seq Scan on employees  (cost=0.00..2.50 rows=1 width=...)
  Filter: (last_name = 'Smith'::text)
```

**Key terms:**
- **Seq Scan** (Sequential Scan) = reading every row. Fine for small tables, **terrible** for large ones.
- **Index Scan** = using an index to jump straight to matching rows. Fast.
- **cost** = estimated effort (startup..total). Lower is better.
- **rows** = estimated rows returned.

### EXPLAIN ANALYZE (Actually Runs It)

```sql
EXPLAIN ANALYZE
SELECT * FROM employees WHERE last_name = 'Smith';
```

This **runs** the query and shows **real** timing:
```
Seq Scan on employees (cost=0.00..2.50 rows=1) (actual time=0.015..0.087 rows=1 loops=1)
Planning Time: 0.120 ms
Execution Time: 0.105 ms
```

> 💡 `EXPLAIN ANALYZE` is your #1 diagnostic tool. The gap between *estimated* and *actual* rows reveals bad statistics. Always look at **Execution Time**.

---

## 📚 Concept 2 — Indexes (The Speed Multiplier)

An index is like a book's index — instead of scanning every page, you jump straight to what you need.

```sql
-- Create an index on a frequently filtered column
CREATE INDEX idx_employees_last_name ON employees(last_name);

-- Now this query uses Index Scan instead of Seq Scan
EXPLAIN ANALYZE
SELECT * FROM employees WHERE last_name = 'Smith';
```

### Common Index Types in PostgreSQL

| Type | Best for |
|------|----------|
| **B-Tree** (default) | `=`, `<`, `>`, `BETWEEN`, `ORDER BY` — most cases |
| **Hash** | Equality `=` only |
| **GIN** | Full-text search, JSONB, arrays |
| **GiST** | Geometric/spatial, ranges |
| **BRIN** | Huge tables with naturally ordered data (time-series) |

### Indexes on Join Keys & Filters

```sql
-- Index foreign keys used in JOINs
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_sales_rep_id ON orders(sales_rep_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- Composite index for multi-column filters
CREATE INDEX idx_emp_dept_salary ON employees(department_id, salary);
```

### Partial Index (Index a Subset)

```sql
-- Only index ACTIVE employees (smaller, faster)
CREATE INDEX idx_active_employees ON employees(department_id)
WHERE status = 'Active';
```

### ⚠️ The Cost of Indexes

Indexes are **not free**:
- They take disk space.
- They **slow down** `INSERT`, `UPDATE`, `DELETE` (every write must update the index).
- Too many indexes hurt write-heavy systems.

**Rule:** Index columns used in `WHERE`, `JOIN`, and `ORDER BY` on large tables. Don't index everything.

---

## 📚 Concept 3 — Query Optimization Techniques

### 1. Select only what you need

```sql
-- BAD: pulls all columns
SELECT * FROM employees WHERE department_id = 7;

-- GOOD: only needed columns (can use index-only scans)
SELECT first_name, last_name FROM employees WHERE department_id = 7;
```

### 2. Filter early, filter often

```sql
-- Push filters into subqueries/CTEs so less data flows downstream
WITH active AS (
    SELECT * FROM employees WHERE status = 'Active'  -- filter first
)
SELECT department_id, AVG(salary) FROM active GROUP BY department_id;
```

### 3. Avoid functions on indexed columns in WHERE

```sql
-- BAD: function disables the index
SELECT * FROM employees WHERE UPPER(last_name) = 'SMITH';

-- GOOD: index works, or create a functional index
SELECT * FROM employees WHERE last_name = 'Smith';
-- OR: CREATE INDEX idx_upper_name ON employees(UPPER(last_name));
```

### 4. Use EXISTS instead of IN for large subqueries (Mission 05)

### 5. Beware of OR — it can prevent index use

```sql
-- OR across different columns may force a Seq Scan.
-- Sometimes UNION ALL of two indexed queries is faster.
```

---

## 📚 Concept 4 — Table Partitioning

Partitioning splits one large table into smaller physical pieces. Queries that filter on the partition key only scan relevant partitions ("partition pruning").

```sql
-- Create a partitioned sales table by year
CREATE TABLE sales_partitioned (
    sale_id     BIGSERIAL,
    sale_date   DATE NOT NULL,
    amount      NUMERIC(12,2),
    customer_id INT
) PARTITION BY RANGE (sale_date);

-- Create partitions per year
CREATE TABLE sales_2023 PARTITION OF sales_partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE sales_2024 PARTITION OF sales_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- A query filtering by date only scans the relevant partition
SELECT SUM(amount) FROM sales_partitioned
WHERE sale_date >= '2024-01-01';   -- only touches sales_2024
```

**Partition strategies:**
- **RANGE** — dates, numeric ranges (most common: by month/year)
- **LIST** — discrete values (by region, country)
- **HASH** — even distribution across N partitions

> 💡 Partitioning shines on **time-series** data where you usually query recent periods. It also makes dropping old data instant (`DROP TABLE sales_2020`).

---

## 📚 Concept 5 — Statistics and ANALYZE

PostgreSQL's planner relies on **statistics** about your data to choose good plans. Stale stats = bad plans.

```sql
-- Update statistics for a table
ANALYZE employees;

-- Update stats for the whole database
ANALYZE;

-- VACUUM reclaims space and updates stats
VACUUM ANALYZE employees;
```

```sql
-- View statistics PostgreSQL has collected
SELECT 
    attname AS column_name,
    n_distinct,
    most_common_vals
FROM pg_stats
WHERE tablename = 'employees';
```

> 💡 PostgreSQL auto-vacuums by default, but after a **big bulk load**, manually run `ANALYZE` so the planner has fresh stats.

---

## ✅ Solving the Performance Crisis

```sql
-- Step 1: Diagnose the slow query
EXPLAIN ANALYZE
SELECT c.company_name, SUM(oi.line_total) AS revenue
FROM customers c
JOIN orders o      ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.company_name;

-- Step 2: Add indexes on the join keys (the usual culprit)
CREATE INDEX idx_orders_customer_id  ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- Step 3: Refresh statistics
VACUUM ANALYZE orders;
VACUUM ANALYZE order_items;

-- Step 4: Re-run EXPLAIN ANALYZE and compare Execution Time
-- (Seq Scans should become Index Scans; time drops dramatically)
```

---

## 🏋️ Exercises

1. Run `EXPLAIN` on `SELECT * FROM employees WHERE salary > 150000`. Is it a Seq Scan?
2. Create an index on `employees(salary)` and re-run. Did the plan change?
3. Use `EXPLAIN ANALYZE` to measure the execution time of a 3-table JOIN before and after adding indexes on the join keys.
4. Create a composite index on `orders(customer_id, order_date)` and explain when it helps.
5. Create a partial index on `orders` for only `Pending` orders.
6. Run `VACUUM ANALYZE` on the `orders` table.
7. Query `pg_stats` to see the `n_distinct` value for `employees.department_id`.
8. Explain why `WHERE EXTRACT(YEAR FROM hire_date) = 2021` is slower than `WHERE hire_date BETWEEN '2021-01-01' AND '2021-12-31'`.

→ Solutions: [SOLUTIONS/MISSION-09.md](../../SOLUTIONS/MISSION-09.md)

---

## 🧪 Quiz

→ [QUIZZES/MISSION-09-quiz.md](../../QUIZZES/MISSION-09-quiz.md)

---

## 🔥 Challenge (Bonus 200 XP)

> Marcus asks: *"Take our slowest dashboard query (customer revenue ranking), profile it with EXPLAIN ANALYZE, identify every Seq Scan, add the optimal set of indexes, and document the before/after execution times. Then explain which indexes you'd NOT add and why."*

---

## 🎓 What You Learned

```
✓ EXPLAIN — see the query plan
✓ EXPLAIN ANALYZE — measure real execution time
✓ Seq Scan vs Index Scan
✓ B-Tree, Hash, GIN, GiST, BRIN index types
✓ Indexing WHERE / JOIN / ORDER BY columns
✓ Partial and composite indexes
✓ The write-cost of indexes
✓ Query optimization techniques
✓ Table partitioning (RANGE, LIST, HASH)
✓ Statistics, ANALYZE, VACUUM
```

**XP EARNED: 1000** (+200 bonus for the challenge)

---

## ➡️ Next Mission

You've mastered OLTP performance. Now design a data warehouse for analytics at scale...

→ [MISSION 10 — Data Warehouse Design](../MISSION-10/README.md)
