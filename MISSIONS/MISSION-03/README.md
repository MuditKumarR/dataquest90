# 🎯 MISSION 03 — Finance Team Needs Reports

```
┌────────────────────────────────────────────────────────────────────┐
│  LEVEL 2: Reporting Analyst                                        │
│  XP AVAILABLE: 600                                                │
│  CONCEPTS: COUNT · SUM · AVG · MIN · MAX · GROUP BY · HAVING      │
│  ESTIMATED TIME: 60 minutes                                       │
└────────────────────────────────────────────────────────────────────┘
```

---

## 📧 The Request

> **From:** Michael Clark (Finance Manager)
> **To:** You (Reporting Analyst)
> **Subject:** Budget review — need aggregated numbers
>
> *"Congrats on the promotion to Reporting Analyst! You've earned it.*
>
> *Budget review season is here. I don't need lists of individual employees — I need totals and averages:*
>
> *- How many employees do we have in total? Per department?*
> *- What's our total payroll cost?*
> *- What's the average salary per department?*
> *- What's the highest and lowest salary in each location?*
> *- And only show me departments where the average salary exceeds $120K — those are the ones the CFO will question.*
>
> *— Michael"*

---

## 🧭 Why This Matters (The Real World)

So far you've returned individual rows. But businesses run on **aggregations** — totals, averages, counts.

Every dashboard, every KPI, every executive metric is an aggregation.

| Role | How they use aggregations |
|------|---------------------------|
| **Analyst** | Builds every KPI: revenue, headcount, averages |
| **Data Engineer** | Pre-aggregates data for fast dashboards |
| **Analytics Engineer** | Defines metrics in the semantic layer |
| **Architect** | Designs fact tables around these calculations |
| **AI Engineer** | Computes feature statistics for ML models |

`GROUP BY` is arguably the most important analytical concept in SQL. Master it and you can build any report.

---

## 📚 Concept 1 — Aggregate Functions

These functions collapse many rows into a single value.

| Function | Returns |
|----------|---------|
| `COUNT(*)` | Number of rows |
| `COUNT(column)` | Number of non-NULL values |
| `SUM(column)` | Total of a numeric column |
| `AVG(column)` | Average of a numeric column |
| `MIN(column)` | Smallest value |
| `MAX(column)` | Largest value |

```sql
-- How many employees total?
SELECT COUNT(*) AS total_employees
FROM employees;
```

```sql
-- Total annual payroll cost
SELECT SUM(salary) AS total_payroll
FROM employees;
```

```sql
-- Several metrics at once
SELECT 
    COUNT(*)      AS headcount,
    SUM(salary)   AS total_payroll,
    AVG(salary)   AS avg_salary,
    MIN(salary)   AS lowest_salary,
    MAX(salary)   AS highest_salary
FROM employees;
```

### COUNT(*) vs COUNT(column)

```sql
SELECT 
    COUNT(*)             AS all_rows,       -- counts every row
    COUNT(phone)         AS has_phone,      -- counts non-NULL phones
    COUNT(termination_date) AS terminated   -- counts non-NULL term dates
FROM employees;
```

> 💡 `COUNT(*)` counts rows. `COUNT(column)` ignores NULLs. This difference is a **classic interview question**.

### Rounding

`AVG` often produces ugly decimals. Use `ROUND`:

```sql
SELECT ROUND(AVG(salary), 2) AS avg_salary
FROM employees;
```

---

## 📚 Concept 2 — GROUP BY

Aggregations become powerful when you group them by a category.

> **The Golden Rule:** Every column in the `SELECT` must either be:
> 1. Inside an aggregate function, OR
> 2. Listed in the `GROUP BY` clause.

```sql
-- Headcount per department
SELECT 
    department_id,
    COUNT(*) AS headcount
FROM employees
GROUP BY department_id
ORDER BY headcount DESC;
```

Read it as: *"For each department_id, count the rows."*

```sql
-- Average salary per department
SELECT 
    department_id,
    COUNT(*)                AS headcount,
    ROUND(AVG(salary), 2)   AS avg_salary,
    SUM(salary)             AS total_cost
FROM employees
GROUP BY department_id
ORDER BY avg_salary DESC;
```

```sql
-- Min and max salary per location
SELECT 
    location,
    MIN(salary) AS lowest,
    MAX(salary) AS highest,
    COUNT(*)    AS employees
FROM employees
GROUP BY location
ORDER BY location;
```

### Grouping by Multiple Columns

```sql
-- Headcount per location AND employment type
SELECT 
    location,
    employment_type,
    COUNT(*) AS headcount
FROM employees
GROUP BY location, employment_type
ORDER BY location, employment_type;
```

---

## 📚 Concept 3 — HAVING

`WHERE` filters **rows**. `HAVING` filters **groups** (after aggregation).

> **The key distinction:**
> - `WHERE` happens *before* grouping — filters individual rows.
> - `HAVING` happens *after* grouping — filters aggregated results.

```sql
-- Departments where average salary exceeds $120K
SELECT 
    department_id,
    ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 120000
ORDER BY avg_salary DESC;
```

You **cannot** use `WHERE AVG(salary) > 120000` — aggregates aren't available yet when `WHERE` runs.

### Combining WHERE and HAVING

```sql
-- Among ACTIVE employees only, find departments
-- with more than 5 people
SELECT 
    department_id,
    COUNT(*) AS active_headcount
FROM employees
WHERE status = 'Active'          -- filter rows first
GROUP BY department_id
HAVING COUNT(*) > 5              -- filter groups after
ORDER BY active_headcount DESC;
```

**Execution order:** `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY`

This order is fundamental. Memorize it.

---

## ✅ Solving Finance's Request

```sql
-- 1. Total headcount
SELECT COUNT(*) AS total_employees FROM employees;

-- 2. Headcount per department
SELECT department_id, COUNT(*) AS headcount
FROM employees
GROUP BY department_id
ORDER BY headcount DESC;

-- 3. Total payroll cost
SELECT SUM(salary) AS total_payroll FROM employees;

-- 4. Average salary per department
SELECT department_id, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id
ORDER BY avg_salary DESC;

-- 5. Highest and lowest salary per location
SELECT location, MAX(salary) AS highest, MIN(salary) AS lowest
FROM employees
GROUP BY location;

-- 6. Departments where avg salary > $120K (CFO's concern)
SELECT department_id, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 120000
ORDER BY avg_salary DESC;
```

---

## 🏋️ Exercises

1. Count how many employees are in each `employment_type`.
2. Find the total `salary` (payroll) per `location`.
3. Find the average `salary` per `status`.
4. Count how many employees are in each `status`, but only show statuses with more than 2 people (`HAVING`).
5. Find the `MIN`, `MAX`, and `AVG` salary across the whole company in one query.
6. For each `location`, count employees and show the total payroll, sorted by total payroll descending.
7. Find departments (`department_id`) that have fewer than 3 employees.
8. Among `Active` employees only, find the average salary per `location`.

→ Solutions: [SOLUTIONS/MISSION-03.md](../../SOLUTIONS/MISSION-03.md)

---

## 🧪 Quiz

→ [QUIZZES/MISSION-03-quiz.md](../../QUIZZES/MISSION-03-quiz.md)

---

## 🔥 Challenge (Bonus 100 XP)

> Michael asks: *"Build me a 'department cost efficiency' report. For each department, show: headcount, total payroll, average salary, and the salary range (max minus min). Only include departments with at least 4 employees, sorted by total payroll descending."*

**Hint:** You can do math inside SELECT: `MAX(salary) - MIN(salary) AS salary_range`.

---

## 🎓 What You Learned

```
✓ COUNT, SUM, AVG, MIN, MAX — aggregate functions
✓ COUNT(*) vs COUNT(column) — the NULL difference
✓ ROUND() — clean up averages
✓ GROUP BY — aggregate per category
✓ The Golden Rule of GROUP BY
✓ HAVING — filter groups after aggregation
✓ WHERE vs HAVING — before vs after grouping
✓ SQL execution order
```

**XP EARNED: 600** (+100 bonus for the challenge)

---

## ➡️ Next Mission

The Sales Director's dashboard is broken — revenue lives in one table, customers in another...

→ [MISSION 04 — Sales Dashboard Emergency](../MISSION-04/README.md)
