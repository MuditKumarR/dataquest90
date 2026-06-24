# 🪟 SQL Window Functions Cheat Sheet (PostgreSQL 17)

> Window functions compute across rows **without collapsing them** — the #1 advanced SQL skill in interviews.

---

## The Anatomy

```sql
function() OVER (
    PARTITION BY column   -- split into groups (optional)
    ORDER BY column       -- order within group (optional)
    ROWS/RANGE ...        -- frame (optional)
)
```

> Unlike GROUP BY, every row stays — you just add a computed column.

---

## Ranking Functions

```sql
ROW_NUMBER() OVER (ORDER BY salary DESC)   -- 1,2,3,4 (always unique)
RANK()       OVER (ORDER BY salary DESC)   -- 1,2,2,4 (gaps on ties)
DENSE_RANK() OVER (ORDER BY salary DESC)   -- 1,2,2,3 (no gaps)
NTILE(4)     OVER (ORDER BY salary DESC)   -- quartiles: 1,1,2,2,3,3,4,4
PERCENT_RANK() OVER (ORDER BY salary)      -- relative rank 0..1
```

```sql
-- Top earner per department
SELECT * FROM (
    SELECT first_name, department_id, salary,
        ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
    FROM employees
) ranked
WHERE rn = 1;
```

## Offset Functions — Compare Across Rows

```sql
LAG(salary) OVER (ORDER BY hire_date)       -- previous row's value
LEAD(salary) OVER (ORDER BY hire_date)      -- next row's value
LAG(salary, 1, 0) OVER (...)                -- offset 1, default 0
```

```sql
-- Month-over-month revenue change
SELECT month, revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS change
FROM monthly_revenue;
```

## First/Last/Nth in Window

```sql
FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY salary DESC)
LAST_VALUE(salary)  OVER (PARTITION BY department_id ORDER BY salary DESC
                          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
NTH_VALUE(salary, 2) OVER (...)
```

> ⚠️ `LAST_VALUE` needs an explicit frame or it only sees up to the current row!

## Aggregate Window Functions

```sql
-- Running total
SUM(revenue) OVER (ORDER BY sale_date) AS running_total

-- Moving average (3-row window)
AVG(revenue) OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)

-- % of partition total
revenue / SUM(revenue) OVER (PARTITION BY region) AS pct_of_region

-- Count within partition
COUNT(*) OVER (PARTITION BY department_id) AS dept_size
```

---

## Frame Clauses

```sql
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW   -- start → here (running total)
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW           -- last 3 rows (moving avg)
ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING    -- here → end
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING  -- whole partition
```

---

## Common Real-World Patterns

```sql
-- Top N per group
ROW_NUMBER() OVER (PARTITION BY dept ORDER BY metric DESC)  -- then WHERE rn <= N

-- Running total
SUM(x) OVER (ORDER BY date)

-- Period-over-period growth
(x - LAG(x) OVER (ORDER BY date)) / LAG(x) OVER (ORDER BY date)

-- Rank within category
RANK() OVER (PARTITION BY category ORDER BY sales DESC)

-- Quartiles / deciles
NTILE(4) OVER (ORDER BY value)

-- Deduplication (keep first)
ROW_NUMBER() OVER (PARTITION BY key ORDER BY created_at) -- then WHERE rn = 1
```

---

## 🧠 Quick Reference

| Want | Function |
|------|----------|
| Unique sequence | `ROW_NUMBER()` |
| Rank with ties+gaps | `RANK()` |
| Rank with ties, no gaps | `DENSE_RANK()` |
| Buckets/quartiles | `NTILE(n)` |
| Previous value | `LAG()` |
| Next value | `LEAD()` |
| Running total | `SUM() OVER (ORDER BY ...)` |
| Moving average | `AVG() OVER (... ROWS BETWEEN ...)` |
| First in group | `FIRST_VALUE()` |

---

## ⚠️ Common Mistakes

- Using window functions in `WHERE` → not allowed (wrap in subquery/CTE).
- `LAST_VALUE` without a full frame → wrong result.
- Forgetting `PARTITION BY` → computes across the whole table.
- Confusing `RANK` vs `DENSE_RANK` vs `ROW_NUMBER` on ties.
