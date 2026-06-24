# Subqueries: Thinking in Layers

> **Level:** L3 (Analytics Engineer) · **Reading time:** 7 minutes

---

## 🎣 The Hook

Some questions can't be answered in one pass. "Find employees who earn more than their department's average." You need to compute something *first*, then use it. That's a subquery — and it's how you learn to think in layers.

---

## 💼 The Business Problem

The Marketing Director asks: *"Which customers spend more than the average customer? And which have never bought our flagship product?"* Both questions require a calculation inside a calculation.

---

## 🧠 The Concept

A subquery is a query inside a query.

```sql
-- Customers above the average lifetime value
SELECT company_name, lifetime_value
FROM customers
WHERE lifetime_value > (SELECT AVG(lifetime_value) FROM customers);
```

The inner query runs first, produces a value, the outer query uses it.

### Correlated Subquery (runs per row)

```sql
-- Employees earning above THEIR department's average
SELECT e.first_name, e.salary, e.department_id
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary) FROM employees
    WHERE department_id = e.department_id   -- references outer row
);
```

### EXISTS / NOT EXISTS

```sql
-- Customers who have placed at least one order
SELECT company_name FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

-- Customers who have NEVER ordered
SELECT company_name FROM customers c
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);
```

### Derived Table (subquery in FROM)

```sql
SELECT department_id, avg_salary
FROM (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees GROUP BY department_id
) dept_avgs
WHERE avg_salary > 70000;
```

---

## ⚠️ The NOT IN + NULL Trap

If a subquery in `NOT IN` returns any NULL, you get *zero* rows. Prefer `NOT EXISTS`, which is NULL-safe.

---

## 🏋️ Try It Yourself

1. Find products priced above the average product price.
2. List employees who earn more than their manager.
3. Find customers with no orders using NOT EXISTS.

→ Practice in [MISSION 5](../MISSIONS/MISSION-05/README.md).

---

## 🔗 References

- [Mission 5: Marketing Customer Intelligence](../MISSIONS/MISSION-05/README.md)

---

## 📣 LinkedIn Summary

> "Find employees who earn more than their department average." You can't answer that in one pass — you compute first, then compare. That's subqueries, and they teach you to think in layers. Here's the toolkit: correlated subqueries, EXISTS, and the NOT IN trap that bites everyone. 👇

**SEO keywords:** SQL subquery, correlated subquery, EXISTS NOT EXISTS, derived table, NOT IN NULL, PostgreSQL subqueries, analytics engineer
