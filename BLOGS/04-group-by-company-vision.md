# GROUP BY Is How Companies See Themselves

> **Level:** L2 (Reporting Analyst) · **Reading time:** 7 minutes

---

## 🎣 The Hook

A company can't make decisions about individual rows. It makes decisions about *groups*: revenue by region, headcount by department, churn by segment. `GROUP BY` is the lens through which a company sees itself.

---

## 💼 The Business Problem

The Finance Manager doesn't want a list of 70 orders. He wants: *"What's our total and average order value, broken down by month, and which months beat $50K?"* That's aggregation plus grouping plus filtering groups.

---

## 🧠 The Concept

Aggregate functions collapse many rows into one summary number:

```sql
SELECT COUNT(*), SUM(salary), AVG(salary), MIN(salary), MAX(salary)
FROM employees;
```

`GROUP BY` computes those summaries *per category*:

```sql
SELECT 
    department_id,
    COUNT(*) AS headcount,
    ROUND(AVG(salary), 0) AS avg_salary
FROM employees
GROUP BY department_id
ORDER BY headcount DESC;
```

`HAVING` filters the groups (after aggregation):

```sql
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 70000;
```

---

## 🔑 WHERE vs HAVING

| | WHERE | HAVING |
|--|-------|--------|
| Filters | rows | groups |
| Runs | before grouping | after grouping |
| Aggregates | no | yes |

```sql
-- Filter rows first, then groups
SELECT department_id, COUNT(*)
FROM employees
WHERE status = 'Active'         -- row filter
GROUP BY department_id
HAVING COUNT(*) > 5;            -- group filter
```

---

## ✨ PostgreSQL Superpower: FILTER

```sql
SELECT 
    department_id,
    COUNT(*) FILTER (WHERE status = 'Active')     AS active,
    COUNT(*) FILTER (WHERE status = 'Terminated') AS terminated
FROM employees
GROUP BY department_id;
```

One pass, multiple conditional counts. This is how real dashboards are built.

---

## 🏋️ Try It Yourself

1. Count customers by industry.
2. Average order value by customer, only those over $5K.
3. Headcount by department split into active vs inactive (use FILTER).

→ Practice in [MISSION 3](../MISSIONS/MISSION-03/README.md).

---

## 🔗 References

- [Mission 3: Finance Reports](../MISSIONS/MISSION-03/README.md)
- [Aggregations Cheat Sheet](../CHEATSHEETS/03-sql-aggregations.md)

---

## 📣 LinkedIn Summary

> Companies don't decide based on rows — they decide based on groups. Revenue by region. Headcount by team. Churn by segment. That's `GROUP BY`, the lens a business uses to see itself. Here's how to master it (plus PostgreSQL's underrated FILTER trick). 👇

**SEO keywords:** SQL GROUP BY, SQL aggregation, HAVING vs WHERE, SQL FILTER, COUNT SUM AVG, PostgreSQL aggregation, reporting analyst
