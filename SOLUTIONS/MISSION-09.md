# ✅ Mission 9 — Solutions

Worked solutions for [Mission 9](../MISSIONS/MISSION-09/README.md). Try first!

---

### 1. EXPLAIN a salary filter

```sql
EXPLAIN SELECT * FROM employees WHERE salary > 150000;
-- On a small/unindexed table you'll typically see a Seq Scan.
```

### 2. Add an index and re-check

```sql
CREATE INDEX idx_employees_salary ON employees(salary);
EXPLAIN SELECT * FROM employees WHERE salary > 150000;
-- The planner may now choose an Index Scan (depends on selectivity/table size).
```

### 3. Measure a 3-table JOIN

```sql
EXPLAIN ANALYZE
SELECT c.company_name, SUM(oi.line_total)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.company_name;

CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
-- Re-run EXPLAIN ANALYZE and compare "actual time".
```

### 4. Composite index on orders

```sql
CREATE INDEX idx_orders_cust_date ON orders(customer_id, order_date);
-- Helps queries filtering by customer_id, or customer_id + order_date
-- (leftmost-prefix rule). Does NOT help filtering by order_date alone.
```

### 5. Partial index for Pending orders

```sql
CREATE INDEX idx_orders_pending ON orders(order_date)
WHERE order_status = 'Pending';
-- Smaller index that only covers rows the dashboard cares about.
```

### 6. Maintenance

```sql
VACUUM ANALYZE orders;
```

### 7. Inspect planner statistics

```sql
SELECT attname, n_distinct, null_frac
FROM pg_stats
WHERE tablename = 'employees' AND attname = 'department_id';
```

### 8. Why the function-wrapped filter is slower

```sql
-- SLOW: function on the column prevents using an index on hire_date
-- WHERE EXTRACT(YEAR FROM hire_date) = 2021

-- FAST: sargable range lets the planner use a B-tree index
-- WHERE hire_date BETWEEN '2021-01-01' AND '2021-12-31'
```

Wrapping a column in a function makes the predicate **non-sargable** — Postgres can't use the index and falls back to scanning every row.

---

## 🔥 Challenge — Profile and optimize the slow query

```sql
EXPLAIN ANALYZE
SELECT c.company_name, SUM(oi.line_total) AS revenue,
       RANK() OVER (ORDER BY SUM(oi.line_total) DESC) AS rev_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.company_name;

-- Add indexes on the join keys:
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
-- Re-run and document before/after "actual time".
-- Do NOT index company_name (low selectivity, used only in GROUP BY output)
-- or boolean/low-cardinality columns — the write cost outweighs the benefit.
```

→ Next: [Mission 10 Solutions](MISSION-10.md)
