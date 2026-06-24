# 🎯 MISSION 07 — Analytics Rankings + Trends

```
┌────────────────────────────────────────────────────────────────────┐
│  LEVEL 3: Analytics Engineer                                       │
│  XP AVAILABLE: 800                                                │
│  CONCEPTS: Window Functions — ROW_NUMBER · RANK · DENSE_RANK      │
│            · NTILE · LAG · LEAD · FIRST_VALUE · LAST_VALUE        │
│  ESTIMATED TIME: 80 minutes                                       │
└────────────────────────────────────────────────────────────────────┘
```

---

## 📧 The Request

> **From:** Angela Davis (Chief Data Officer)
> **To:** You (Analytics Engineer)
> **Subject:** Executive analytics dashboard — rankings & trends
>
> *"The executives want sophisticated analytics:*
>
> *- Rank our sales reps by revenue — show #1, #2, #3...*
> *- Within each department, who are the top 3 earners?*
> *- Show month-over-month revenue growth (this month vs last month).*
> *- Split our customers into 4 equal spending quartiles.*
>
> *This needs 'window functions'. They're the difference between a junior and senior analyst. Show me you've got it.*
>
> *— Angela"*

---

## 🧭 Why This Matters (The Real World)

Window functions are the **#1 skill that separates senior analysts from juniors**. They let you do rankings, running totals, and period-over-period comparisons — things that are painful or impossible with `GROUP BY` alone.

The key difference:
- `GROUP BY` **collapses** rows into summary rows.
- Window functions **keep every row** and add a calculated column alongside.

| Role | How they use window functions |
|------|-------------------------------|
| **Analyst** | Rankings, top-N-per-group, trends |
| **Analytics Engineer** | Running totals, period comparisons |
| **Data Engineer** | Deduplication (ROW_NUMBER) |
| **AI Engineer** | Time-series features, lag features for ML |

---

## 📚 The Anatomy of a Window Function

```sql
FUNCTION() OVER (
    PARTITION BY column   -- optional: reset per group
    ORDER BY column       -- optional: order within the window
)
```

- `OVER()` — the magic that makes it a window function
- `PARTITION BY` — like GROUP BY, but doesn't collapse rows
- `ORDER BY` — defines the order for ranking/running calculations

---

## 📚 Concept 1 — ROW_NUMBER, RANK, DENSE_RANK

All three assign a number based on order. They differ in how they handle **ties**.

```sql
-- Rank sales reps by total revenue
WITH rep_revenue AS (
    SELECT 
        e.employee_id,
        e.first_name || ' ' || e.last_name AS rep,
        SUM(oi.line_total) AS revenue
    FROM employees e
    JOIN orders o      ON e.employee_id = o.sales_rep_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY e.employee_id, e.first_name, e.last_name
)
SELECT 
    rep,
    revenue,
    ROW_NUMBER() OVER (ORDER BY revenue DESC) AS row_num,
    RANK()       OVER (ORDER BY revenue DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY revenue DESC) AS dense_rank
FROM rep_revenue;
```

### How They Handle Ties

Given values `100, 100, 90, 80`:

| Value | ROW_NUMBER | RANK | DENSE_RANK |
|-------|-----------|------|-----------|
| 100 | 1 | 1 | 1 |
| 100 | 2 | 1 | 1 |
| 90 | 3 | **3** | **2** |
| 80 | 4 | 4 | 3 |

- **ROW_NUMBER** — always unique, even for ties (1,2,3,4)
- **RANK** — ties share a rank, then skips (1,1,3,4)
- **DENSE_RANK** — ties share a rank, no skip (1,1,2,3)

> 💡 Use **ROW_NUMBER** for deduplication and top-N. Use **RANK/DENSE_RANK** for leaderboards.

---

## 📚 Concept 2 — PARTITION BY (Top-N Per Group)

`PARTITION BY` restarts the ranking for each group. This is the famous **"top N per category"** pattern.

```sql
-- Top 3 highest-paid employees IN EACH department
WITH ranked AS (
    SELECT 
        first_name || ' ' || last_name AS name,
        department_id,
        salary,
        ROW_NUMBER() OVER (
            PARTITION BY department_id   -- restart per department
            ORDER BY salary DESC
        ) AS dept_rank
    FROM employees
)
SELECT name, department_id, salary, dept_rank
FROM ranked
WHERE dept_rank <= 3            -- keep only top 3 per department
ORDER BY department_id, dept_rank;
```

This is one of the **most-asked interview questions** in all of SQL. The trick: rank in a CTE, then filter in the outer query (you can't filter a window function directly in WHERE).

---

## 📚 Concept 3 — NTILE (Quartiles / Buckets)

`NTILE(n)` splits rows into `n` roughly-equal buckets.

```sql
-- Split customers into 4 spending quartiles
WITH spend AS (
    SELECT 
        c.company_name,
        c.lifetime_value
    FROM customers c
    WHERE c.lifetime_value > 0
)
SELECT 
    company_name,
    lifetime_value,
    NTILE(4) OVER (ORDER BY lifetime_value DESC) AS quartile
FROM spend
ORDER BY lifetime_value DESC;
```

Quartile 1 = top spenders, quartile 4 = lowest. Perfect for segmentation, deciles (`NTILE(10)`), or percentiles.

---

## 📚 Concept 4 — LAG and LEAD (Period-over-Period)

`LAG` looks at the **previous** row; `LEAD` looks at the **next** row. Essential for trends.

```sql
-- Month-over-month revenue growth
WITH monthly AS (
    SELECT 
        fiscal_year,
        fiscal_month,
        SUM(revenue) AS revenue
    FROM sales_transactions
    GROUP BY fiscal_year, fiscal_month
)
SELECT 
    fiscal_year,
    fiscal_month,
    revenue,
    LAG(revenue) OVER (ORDER BY fiscal_year, fiscal_month) AS prev_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY fiscal_year, fiscal_month) AS change,
    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY fiscal_year, fiscal_month))
        / NULLIF(LAG(revenue) OVER (ORDER BY fiscal_year, fiscal_month), 0),
    2) AS growth_pct
FROM monthly
ORDER BY fiscal_year, fiscal_month;
```

- `LAG(revenue)` returns the previous month's revenue on the same row.
- `NULLIF(..., 0)` prevents division-by-zero errors.
- The first row has `NULL` for `prev_month_revenue` (nothing before it).

> 💡 This single pattern powers nearly every "growth %", "vs last period", and "trend" metric in business.

---

## 📚 Concept 5 — FIRST_VALUE and LAST_VALUE

Return the first or last value within the window.

```sql
-- Compare each employee's salary to the highest in their department
SELECT 
    first_name || ' ' || last_name AS name,
    department_id,
    salary,
    FIRST_VALUE(salary) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS dept_top_salary,
    salary - FIRST_VALUE(salary) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS gap_to_top
FROM employees
ORDER BY department_id, salary DESC;
```

---

## 📚 Concept 6 — Running Totals (Bonus Pattern)

Aggregate functions become window functions with `OVER` + `ORDER BY`.

```sql
-- Cumulative (running) revenue over time
WITH monthly AS (
    SELECT fiscal_year, fiscal_month, SUM(revenue) AS revenue
    FROM sales_transactions
    GROUP BY fiscal_year, fiscal_month
)
SELECT 
    fiscal_year,
    fiscal_month,
    revenue,
    SUM(revenue) OVER (
        ORDER BY fiscal_year, fiscal_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM monthly
ORDER BY fiscal_year, fiscal_month;
```

---

## ✅ Solving the CDO's Request

```sql
-- 1. Rank reps by revenue (Concept 1)
-- 2. Top 3 earners per department (Concept 2 — PARTITION BY)
-- 3. Month-over-month growth (Concept 4 — LAG)
-- 4. Customer quartiles (Concept 3 — NTILE)
-- All shown above. The CDO gets a complete analytics dashboard.
```

---

## 🏋️ Exercises

1. Rank all employees by salary using `RANK()` (highest = rank 1).
2. Within each `location`, number employees by salary using `ROW_NUMBER()`.
3. Find the top 2 highest-paid employees per department.
4. Split all employees into 5 salary bands using `NTILE(5)`.
5. For monthly sales, show each month's revenue and the **next** month's revenue using `LEAD`.
6. For each employee, show their salary and the average salary of their department using `AVG(salary) OVER (PARTITION BY department_id)`.
7. Calculate a running total of `budgeted_amount` over quarters from `finance_budget` for department 4.
8. For each customer, show their `lifetime_value` and their rank within their industry using `DENSE_RANK() OVER (PARTITION BY industry ORDER BY lifetime_value DESC)`.

→ Solutions: [SOLUTIONS/MISSION-07.md](../../SOLUTIONS/MISSION-07.md)

---

## 🧪 Quiz

→ [QUIZZES/MISSION-07-quiz.md](../../QUIZZES/MISSION-07-quiz.md)

---

## 🔥 Challenge (Bonus 150 XP)

> Angela asks: *"Build the 'Sales Leaderboard with Momentum' report. For each sales rep, show: their total revenue, their overall rank, their revenue last year, this year, and the year-over-year growth %. Highlight who is rising and who is falling."*

**Hints:** Combine `RANK()`, `LAG()` partitioned by rep over years, and growth % math with `NULLIF`.

---

## 🎓 What You Learned

```
✓ OVER() — the window function clause
✓ PARTITION BY — reset calculations per group
✓ ROW_NUMBER, RANK, DENSE_RANK — and how ties differ
✓ Top-N-per-group pattern (rank in CTE, filter outside)
✓ NTILE — quartiles, deciles, percentiles
✓ LAG / LEAD — previous/next row comparisons
✓ FIRST_VALUE / LAST_VALUE
✓ Running totals with SUM() OVER
✓ NULLIF — safe division
```

**XP EARNED: 800** (+150 bonus for the challenge)

---

## ➡️ Next Mission

You're now an Analytics Engineer. Time to consolidate data from multiple systems...

→ [MISSION 08 — Enterprise Reporting Architecture](../MISSION-08/README.md)
