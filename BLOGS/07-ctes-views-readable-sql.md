# CTEs and Views: Writing SQL Humans Can Read

> **Level:** L3 (Analytics Engineer) · **Reading time:** 7 minutes

---

## 🎣 The Hook

There's SQL that works, and there's SQL that works *and* the next person can understand six months later. The difference is usually CTEs and Views. They're how you go from "clever query writer" to "engineer who builds maintainable systems."

---

## 💼 The Business Problem

The Data Team lead says: *"Stop copy-pasting the same 40-line revenue query into every report. Build it once, name it, and let everyone reuse it."* That's exactly what CTEs and Views solve.

---

## 🧠 The Concept: CTEs

A Common Table Expression (`WITH`) names a temporary result, making complex queries readable top-to-bottom:

```sql
WITH dept_revenue AS (
    SELECT e.department_id, SUM(st.revenue) AS revenue
    FROM sales_transactions st
    JOIN employees e ON st.sales_rep_id = e.employee_id
    GROUP BY e.department_id
),
ranked AS (
    SELECT *, RANK() OVER (ORDER BY revenue DESC) AS rnk
    FROM dept_revenue
)
SELECT * FROM ranked WHERE rnk <= 3;
```

Read it like a story: compute revenue → rank it → take the top 3. Far clearer than nested subqueries.

---

## 🔁 Recursive CTEs

For hierarchies (org charts, categories, graphs):

```sql
WITH RECURSIVE org AS (
    SELECT employee_id, first_name, manager_id, 1 AS level
    FROM employees WHERE manager_id IS NULL    -- the CEO
    UNION ALL
    SELECT e.employee_id, e.first_name, e.manager_id, o.level + 1
    FROM employees e JOIN org o ON e.manager_id = o.employee_id
)
SELECT * FROM org ORDER BY level;
```

---

## 🖼️ The Concept: Views

A View is a saved query you can treat like a table:

```sql
CREATE VIEW vw_active_employees AS
SELECT employee_id, first_name, last_name, department_id, salary
FROM employees WHERE status = 'Active';

-- Now anyone can:
SELECT * FROM vw_active_employees WHERE salary > 80000;
```

### Materialized Views (cached for speed)

```sql
CREATE MATERIALIZED VIEW mv_monthly_revenue AS
SELECT DATE_TRUNC('month', sale_date) AS month, SUM(revenue) AS revenue
FROM sales_transactions GROUP BY 1;

REFRESH MATERIALIZED VIEW mv_monthly_revenue;   -- update on demand
```

| View | Materialized View |
|------|-------------------|
| Always fresh | Cached (needs refresh) |
| Computed each query | Stored physically |
| Slower on big data | Fast reads, stale data |

---

## 🏋️ Try It Yourself

1. Rewrite a nested subquery using CTEs.
2. Create a view of high-value customers.
3. Build a recursive CTE listing the management chain above any employee.

→ Practice in [MISSION 6](../MISSIONS/MISSION-06/README.md).

---

## 🔗 References

- [Mission 6: Reusable Logic with CTEs & Views](../MISSIONS/MISSION-06/README.md)

---

## 📣 LinkedIn Summary

> There's SQL that works, and SQL that works AND the next engineer can read it. The difference is CTEs and Views. They turn tangled nested queries into readable, reusable building blocks — and they're how you stop copy-pasting the same 40-line query everywhere. 🧵

**SEO keywords:** SQL CTE, WITH clause, recursive CTE, SQL views, materialized view, readable SQL, PostgreSQL CTE, analytics engineer
