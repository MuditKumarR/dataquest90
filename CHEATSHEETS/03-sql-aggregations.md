# 📊 SQL Aggregations Cheat Sheet (PostgreSQL 17)

> Aggregations turn many rows into summary insights.

---

## Core Aggregate Functions

```sql
COUNT(*)            -- count all rows
COUNT(column)       -- count non-NULL values
COUNT(DISTINCT col) -- count unique values
SUM(salary)         -- total
AVG(salary)         -- average
MIN(salary) / MAX(salary)
```

## GROUP BY — Summarize by Category

```sql
SELECT department_id, COUNT(*) AS headcount, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;

-- Group by multiple columns
SELECT department_id, employment_type, COUNT(*)
FROM employees
GROUP BY department_id, employment_type;
```

> 🔑 Rule: every non-aggregated column in SELECT must be in GROUP BY.

## HAVING — Filter Groups

```sql
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 70000;     -- filter AFTER grouping
```

| WHERE | HAVING |
|-------|--------|
| Filters rows | Filters groups |
| Before GROUP BY | After GROUP BY |
| Can't use aggregates | Can use aggregates |

## FILTER — Conditional Aggregates (PostgreSQL)

```sql
SELECT 
    department_id,
    COUNT(*) AS total,
    COUNT(*) FILTER (WHERE status = 'Active')     AS active,
    SUM(salary) FILTER (WHERE employment_type = 'Full-Time') AS ft_payroll,
    ROUND(AVG(salary) FILTER (WHERE gender = 'Female'), 0)   AS avg_female_salary
FROM employees
GROUP BY department_id;
```

> 💡 `FILTER` is cleaner than `CASE` inside aggregates and is PostgreSQL-native.

## Statistical Aggregates

```sql
STDDEV(salary)              -- standard deviation
VARIANCE(salary)
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary)  -- median
MODE() WITHIN GROUP (ORDER BY department_id)         -- most frequent
```

## String Aggregation

```sql
-- Combine values into a list
SELECT department_id, STRING_AGG(first_name, ', ' ORDER BY first_name) AS team
FROM employees
GROUP BY department_id;

-- Aggregate into an array
SELECT department_id, ARRAY_AGG(salary) FROM employees GROUP BY department_id;
```

## GROUPING SETS, ROLLUP, CUBE — Multi-Level Totals

```sql
-- Subtotals + grand total in one query
SELECT department_id, employment_type, COUNT(*)
FROM employees
GROUP BY ROLLUP (department_id, employment_type);

-- All combinations of subtotals
GROUP BY CUBE (department_id, employment_type);

-- Specific grouping combinations
GROUP BY GROUPING SETS ((department_id), (employment_type), ());
```

---

## Percentage of Total (window + aggregate)

```sql
SELECT 
    department_id,
    COUNT(*) AS headcount,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_company
FROM employees
GROUP BY department_id;
```

---

## 🧠 Quick Patterns

| Need | Pattern |
|------|---------|
| Count by category | `GROUP BY x` |
| Filter groups | `HAVING agg(...) > n` |
| Conditional count | `COUNT(*) FILTER (WHERE ...)` |
| Median | `PERCENTILE_CONT(0.5) WITHIN GROUP` |
| List values | `STRING_AGG` |
| Subtotals + total | `ROLLUP` |
| % of total | `agg / SUM(agg) OVER ()` |

---

## ⚠️ Common Mistakes

- Putting a non-aggregated column in SELECT but not in GROUP BY → error.
- Using WHERE to filter aggregates (use HAVING).
- Forgetting `100.0 *` for percentages → integer division gives 0.
- `COUNT(column)` skips NULLs — use `COUNT(*)` to count all rows.
