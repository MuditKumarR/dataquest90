# 🎯 SQL Interview Questions Cheat Sheet

> The patterns that appear in 90% of SQL interviews. Memorize these.

---

## 1. Second Highest Salary

```sql
-- Method A: subquery
SELECT MAX(salary) FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- Method B: DENSE_RANK (handles ties, generalizes to Nth)
SELECT DISTINCT salary FROM (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
) x WHERE rnk = 2;
```

## 2. Top N Per Group

```sql
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
    FROM employees
) x WHERE rn <= 3;
```

## 3. Find Duplicates

```sql
SELECT email, COUNT(*) 
FROM employees
GROUP BY email
HAVING COUNT(*) > 1;
```

## 4. Delete Duplicates (keep one)

```sql
DELETE FROM employees a
USING employees b
WHERE a.employee_id > b.employee_id
  AND a.email = b.email;
```

## 5. Running Total

```sql
SELECT sale_date, revenue,
    SUM(revenue) OVER (ORDER BY sale_date) AS running_total
FROM sales_transactions;
```

## 6. Month-over-Month Growth

```sql
WITH m AS (
    SELECT DATE_TRUNC('month', sale_date) AS month, SUM(revenue) AS rev
    FROM sales_transactions GROUP BY 1
)
SELECT month, rev,
    ROUND(100.0*(rev - LAG(rev) OVER (ORDER BY month))
          / NULLIF(LAG(rev) OVER (ORDER BY month),0), 1) AS mom_pct
FROM m;
```

## 7. Employees Earning More Than Their Manager

```sql
SELECT e.first_name
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;
```

## 8. Departments With No Employees

```sql
SELECT d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;
```

## 9. Cumulative Distribution / Percentile

```sql
SELECT first_name, salary,
    NTILE(4) OVER (ORDER BY salary) AS quartile,
    PERCENT_RANK() OVER (ORDER BY salary) AS pct_rank
FROM employees;
```

## 10. Pivot (rows → columns)

```sql
SELECT 
    department_id,
    COUNT(*) FILTER (WHERE employment_type = 'Full-Time') AS full_time,
    COUNT(*) FILTER (WHERE employment_type = 'Contract')  AS contract,
    COUNT(*) FILTER (WHERE employment_type = 'Intern')    AS intern
FROM employees
GROUP BY department_id;
```

## 11. Median

```sql
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary
FROM employees;
```

## 12. Consecutive / Gaps and Islands

```sql
-- Find consecutive login streaks (gaps-and-islands)
SELECT user_id, MIN(day) AS streak_start, MAX(day) AS streak_end, COUNT(*) AS days
FROM (
    SELECT user_id, day,
        day - (ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY day))::int AS grp
    FROM logins
) x
GROUP BY user_id, grp;
```

## 13. Self-Join for Pairs

```sql
-- Pairs of employees in the same department
SELECT a.first_name, b.first_name
FROM employees a
JOIN employees b ON a.department_id = b.department_id
                 AND a.employee_id < b.employee_id;
```

## 14. Conditional Aggregation Ratio

```sql
SELECT 
    ROUND(100.0 * COUNT(*) FILTER (WHERE status='Active') / COUNT(*), 1) AS active_pct
FROM employees;
```

## 15. NULL-Safe Comparison

```sql
WHERE a IS DISTINCT FROM b;     -- treats NULLs as comparable
```

---

## 🧠 Pattern Recognition

| Interview phrase | Technique |
|------------------|-----------|
| "Nth highest" | `DENSE_RANK` |
| "Top N per group" | `ROW_NUMBER` + PARTITION |
| "Running/cumulative" | `SUM() OVER (ORDER BY)` |
| "Compared to previous" | `LAG` |
| "Find duplicates" | `GROUP BY ... HAVING COUNT > 1` |
| "Rows in A not in B" | `LEFT JOIN ... IS NULL` |
| "Pivot" | `COUNT(*) FILTER` |
| "Median/percentile" | `PERCENTILE_CONT` |
| "Streaks/consecutive" | gaps-and-islands |

---

## 💡 Interview Tips

1. **Clarify first** — ask about NULLs, ties, duplicates.
2. **Think out loud** — explain your approach before writing.
3. **Start simple** — get a working query, then optimize.
4. **Know window functions cold** — they're in most interviews.
5. **Watch for ties** — `RANK` vs `DENSE_RANK` vs `ROW_NUMBER`.
