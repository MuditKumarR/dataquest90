# 🎯 MISSION 06 — Data Team Needs Reusable Logic

```
┌────────────────────────────────────────────────────────────────────┐
│  LEVEL 3: Analytics Engineer                                       │
│  XP AVAILABLE: 700                                                │
│  CONCEPTS: CTEs (WITH) · Recursive CTEs · Views                   │
│            · Materialized Views                                    │
│  ESTIMATED TIME: 70 minutes                                       │
└────────────────────────────────────────────────────────────────────┘
```

---

## 📧 The Problem

> **From:** Angela Davis (Chief Data Officer)
> **To:** You (Analytics Engineer)
> **Subject:** Our queries are unmaintainable
>
> *"Our analysts keep copy-pasting the same 50-line subqueries into every report. When the logic changes, we have to update it in 20 places. It's chaos.*
>
> *I need you to make our SQL readable and reusable. I've heard CTEs make queries much cleaner. And I need an org-chart query that shows the full management chain — apparently that requires a 'recursive' query?*
>
> *Also, the executive dashboard is slow because it recalculates everything every time. Can we 'cache' the results somehow?*
>
> *— Angela"*

---

## 🧭 Why This Matters (The Real World)

As queries grow, nested subqueries become unreadable. **CTEs (Common Table Expressions)** break complex logic into named, readable steps.

This is the foundation of modern analytics engineering — tools like **dbt** are essentially CTEs organized into files.

| Role | How they use CTEs/Views |
|------|--------------------------|
| **Analyst** | Readable multi-step reports |
| **Analytics Engineer** | The building block of dbt models |
| **Data Engineer** | Staging logic in pipelines |
| **Architect** | Views as a semantic/abstraction layer |
| **AI Engineer** | Reusable feature definitions |

---

## 📚 Concept 1 — CTE (Common Table Expression)

A CTE is a named temporary result set defined with `WITH`. Think of it as a variable for a query.

```sql
-- Instead of a messy nested subquery...
WITH customer_spend AS (
    SELECT 
        o.customer_id,
        SUM(oi.line_total) AS total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT 
    c.company_name,
    cs.total_spent
FROM customer_spend cs
JOIN customers c ON cs.customer_id = c.customer_id
ORDER BY cs.total_spent DESC;
```

**Read it top to bottom:**
1. `WITH customer_spend AS (...)` defines a reusable result called `customer_spend`.
2. The main query uses it like a normal table.

Compare this to the same logic as a nested subquery — the CTE version is far easier to read.

---

## 📚 Concept 2 — Multiple CTEs (Chained Steps)

You can define several CTEs, each building on the previous. This is how analytics engineers think — in **pipeline steps**.

```sql
WITH 
-- Step 1: total spend per customer
customer_spend AS (
    SELECT o.customer_id, SUM(oi.line_total) AS total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
),
-- Step 2: classify customers into tiers
customer_tiers AS (
    SELECT 
        customer_id,
        total_spent,
        CASE 
            WHEN total_spent > 200000 THEN 'Platinum'
            WHEN total_spent > 100000 THEN 'Gold'
            WHEN total_spent > 50000  THEN 'Silver'
            ELSE 'Bronze'
        END AS tier
    FROM customer_spend
)
-- Final: join back to names and report
SELECT 
    c.company_name,
    ct.tier,
    ct.total_spent
FROM customer_tiers ct
JOIN customers c ON ct.customer_id = c.customer_id
ORDER BY ct.total_spent DESC;
```

Each CTE is a clean, testable step. This pattern scales to enormous complexity while staying readable.

---

## 📚 Concept 3 — Recursive CTE

A recursive CTE references **itself** — perfect for hierarchies and graphs (org charts, bill-of-materials, folder trees).

```sql
-- Build the full management chain from the CEO down
WITH RECURSIVE org_chart AS (
    -- Anchor: start with the top (CEO has no manager)
    SELECT 
        employee_id,
        first_name || ' ' || last_name AS name,
        manager_id,
        1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive: find everyone who reports to the previous level
    SELECT 
        e.employee_id,
        e.first_name || ' ' || e.last_name,
        e.manager_id,
        oc.level + 1
    FROM employees e
    JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT 
    REPEAT('    ', level - 1) || name AS org_tree,
    level
FROM org_chart
ORDER BY level, name;
```

**How it works:**
1. **Anchor member** — the starting point (CEO).
2. **`UNION ALL`** — combines anchor with recursive results.
3. **Recursive member** — joins back to the CTE to find the next level down.
4. PostgreSQL repeats until no new rows are found.

The `REPEAT('    ', level - 1)` indents each level to draw a visual tree.

> ⚠️ Always have a terminating condition (here, the hierarchy naturally ends). A bad recursive CTE can loop forever — PostgreSQL has safety limits but design carefully.

---

## 📚 Concept 4 — Views

A **view** is a saved query you can treat like a table. It does **not** store data — it re-runs the query each time.

```sql
-- Create a reusable view
CREATE OR REPLACE VIEW v_customer_revenue AS
SELECT 
    c.customer_id,
    c.company_name,
    c.industry,
    COUNT(DISTINCT o.order_id)   AS order_count,
    COALESCE(SUM(oi.line_total), 0) AS total_revenue
FROM customers c
LEFT JOIN orders o      ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.company_name, c.industry;

-- Now query it like a table — forever
SELECT * FROM v_customer_revenue
WHERE total_revenue > 100000
ORDER BY total_revenue DESC;
```

Now the logic lives in **one place**. Update the view, and every report using it updates too. This solves Angela's "20 places" problem.

---

## 📚 Concept 5 — Materialized Views

A **materialized view** physically **stores** the results on disk. It's fast to read but must be refreshed to get new data.

```sql
-- Create a materialized view (stores the data)
CREATE MATERIALIZED VIEW mv_monthly_revenue AS
SELECT 
    fiscal_year,
    fiscal_month,
    SUM(revenue)      AS total_revenue,
    SUM(gross_profit) AS total_profit,
    COUNT(*)          AS transaction_count
FROM sales_transactions
GROUP BY fiscal_year, fiscal_month;

-- Query it — instant, because it's precomputed
SELECT * FROM mv_monthly_revenue ORDER BY fiscal_year, fiscal_month;

-- Refresh when underlying data changes
REFRESH MATERIALIZED VIEW mv_monthly_revenue;
```

### View vs Materialized View

| | View | Materialized View |
|--|------|-------------------|
| Stores data? | No | Yes (on disk) |
| Always current? | Yes | Only after REFRESH |
| Read speed | Slower (re-runs query) | Fast (precomputed) |
| Best for | Simple abstraction | Expensive dashboards |

Materialized views solve Angela's "slow dashboard" problem — precompute once, read many times.

---

## ✅ Solving the CDO's Request

```sql
-- 1. Clean, reusable revenue logic via CTE → View
CREATE OR REPLACE VIEW v_customer_revenue AS
WITH spend AS (
    SELECT o.customer_id, SUM(oi.line_total) AS total
    FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT c.company_name, COALESCE(s.total, 0) AS revenue
FROM customers c LEFT JOIN spend s ON c.customer_id = s.customer_id;

-- 2. Org chart via recursive CTE (see Concept 3)

-- 3. Cached dashboard via materialized view (see Concept 5)
```

---

## 🏋️ Exercises

1. Write a CTE that calculates total payroll per department, then join it to `departments` to show department names.
2. Write a two-step CTE: first compute average salary per department, then return only departments above the company-wide average.
3. Build a recursive CTE listing all employees who report (directly or indirectly) to the CTO (employee_id 3).
4. Create a view `v_active_employees` showing only `Active` employees with their department names.
5. Create a materialized view `mv_dept_headcount` with headcount and average salary per department. Then refresh it.
6. Use a CTE to find the top 5 customers by revenue, then show what % of total company revenue each represents.
7. Write a recursive CTE that generates numbers 1 through 10 (hint: anchor `SELECT 1`, recursive `n+1 WHERE n < 10`).

→ Solutions: [SOLUTIONS/MISSION-06.md](../../SOLUTIONS/MISSION-06.md)

---

## 🧪 Quiz

→ [QUIZZES/MISSION-06-quiz.md](../../QUIZZES/MISSION-06-quiz.md)

---

## 🔥 Challenge (Bonus 100 XP)

> Angela asks: *"Build a 'management depth' report. For every employee, show their name, their direct manager's name, and how many levels deep they are in the org (CEO = level 1). Use a recursive CTE."*

---

## 🎓 What You Learned

```
✓ CTE (WITH) — named, readable query steps
✓ Multiple chained CTEs — pipeline thinking
✓ Recursive CTEs — hierarchies and org charts
✓ Anchor + recursive member + UNION ALL
✓ Views — reusable logic in one place
✓ Materialized Views — cached/precomputed results
✓ REFRESH MATERIALIZED VIEW
✓ View vs Materialized View tradeoffs
```

**XP EARNED: 700** (+100 bonus for the challenge)

---

## ➡️ Next Mission

The analytics team needs rankings, running totals, and period-over-period trends...

→ [MISSION 07 — Analytics Rankings + Trends](../MISSION-07/README.md)
