# Window Functions: The Interview Killer

> **Level:** L3 (Analytics Engineer) · **Reading time:** 9 minutes

---

## 🎣 The Hook

If there's one SQL topic that decides data interviews, it's window functions. They're powerful, they're elegant, and they trip up everyone who only learned `GROUP BY`. Master them and you'll out-query 90% of candidates.

---

## 💼 The Business Problem

The Chief Data Officer wants: *"Rank our sales reps within each region, show each month's revenue alongside the previous month, and give me a running total for the year."* `GROUP BY` can't do any of these without losing the detail rows. Window functions can.

---

## 🧠 The Concept

A window function computes across a set of related rows **without collapsing them**:

```sql
function() OVER (PARTITION BY ... ORDER BY ... [frame])
```

Unlike `GROUP BY`, every row survives — you just add a computed column.

### Ranking

```sql
SELECT 
    first_name, department_id, salary,
    ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn,
    RANK()       OVER (PARTITION BY department_id ORDER BY salary DESC) AS rnk,
    DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dense
FROM employees;
```

| Function | Ties | Result |
|----------|------|--------|
| `ROW_NUMBER` | always unique | 1,2,3,4 |
| `RANK` | share, then gap | 1,2,2,4 |
| `DENSE_RANK` | share, no gap | 1,2,2,3 |

### Compare Across Rows (LAG/LEAD)

```sql
SELECT month, revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month,
    revenue - LAG(revenue) OVER (ORDER BY month) AS change
FROM monthly_revenue;
```

### Running Totals & Moving Averages

```sql
SELECT sale_date, revenue,
    SUM(revenue) OVER (ORDER BY sale_date) AS running_total,
    AVG(revenue) OVER (ORDER BY sale_date 
                       ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3
FROM sales_transactions;
```

---

## 🏆 The #1 Interview Pattern: Top-N Per Group

```sql
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
    FROM employees
) x WHERE rn <= 3;   -- top 3 earners per department
```

You **must** wrap it — window functions can't go in `WHERE` directly.

---

## ⚠️ The LAST_VALUE Gotcha

`LAST_VALUE` defaults to a frame ending at the current row, so it returns the current row, not the last. Fix it:

```sql
LAST_VALUE(salary) OVER (
    PARTITION BY department_id ORDER BY salary
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
```

---

## 🏋️ Try It Yourself

1. Rank customers by revenue within each industry.
2. Show monthly revenue with month-over-month % change.
3. Get the top 2 products by sales per category.

→ Practice in [MISSION 7](../MISSIONS/MISSION-07/README.md).

---

## 🔗 References

- [Mission 7: Rankings & Trends](../MISSIONS/MISSION-07/README.md)
- [Window Functions Cheat Sheet](../CHEATSHEETS/04-sql-window-functions.md)

---

## 📣 LinkedIn Summary

> If one SQL topic decides data interviews, it's window functions. ROW_NUMBER vs RANK vs DENSE_RANK, LAG/LEAD, running totals, top-N-per-group — they trip up everyone who only learned GROUP BY. Here's the complete mental model (including the LAST_VALUE gotcha). 🧵

**SEO keywords:** SQL window functions, ROW_NUMBER RANK DENSE_RANK, LAG LEAD, running total, top N per group, SQL interview, PostgreSQL window functions
