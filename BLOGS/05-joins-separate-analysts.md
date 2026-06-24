# JOINs: The Skill That Separates Analysts

> **Level:** L2 (Reporting Analyst) · **Reading time:** 8 minutes

---

## 🎣 The Hook

There's a clear line between people who *think they know SQL* and people who *actually know SQL*: **JOINs**. Real data lives in many tables. The ability to combine them correctly is what makes you dangerous (in a good way).

---

## 💼 The Business Problem

The VP of Sales sends an urgent message: *"I need a report showing each order, the customer's company name, the sales rep, and the product — by tomorrow."* That data lives in four different tables. One report. Four joins.

---

## 🧠 The Concept

A JOIN combines rows from tables based on a related column:

```sql
SELECT 
    o.order_id,
    c.company_name,
    e.first_name || ' ' || e.last_name AS sales_rep,
    p.product_name
FROM orders o
JOIN customers c    ON o.customer_id = c.customer_id
JOIN employees e    ON o.sales_rep_id = e.employee_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id;
```

---

## 🔗 The Join Types

```
INNER  → only matching rows in both
LEFT   → all left rows + matches (NULLs if none)
RIGHT  → all right rows + matches
FULL   → everything from both
```

The most important distinction in practice:

```sql
-- INNER: drops departments with zero employees
SELECT d.department_name, COUNT(e.employee_id)
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- LEFT: keeps every department, showing 0 where empty
SELECT d.department_name, COUNT(e.employee_id)
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;
```

Choosing `INNER` when you needed `LEFT` silently hides data — a classic, costly mistake.

---

## 🪞 The SELF JOIN

A table joined to itself — perfect for hierarchies:

```sql
-- Employees with their managers
SELECT e.first_name AS employee, m.first_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;
```

---

## 🕵️ The Anti-Join (find what's missing)

```sql
-- Customers who have never placed an order
SELECT c.company_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
```

---

## 🏋️ Try It Yourself

1. Join orders to customers and show company name per order.
2. List every department with its headcount (keep zeros).
3. Find products that have never been ordered.

→ Practice in [MISSION 4](../MISSIONS/MISSION-04/README.md).

---

## 🔗 References

- [Mission 4: Sales Dashboard Emergency](../MISSIONS/MISSION-04/README.md)
- [Joins Cheat Sheet](../CHEATSHEETS/02-sql-joins.md)

---

## 📣 LinkedIn Summary

> There's a line between people who think they know SQL and people who actually do: JOINs. Real data lives across many tables, and combining them correctly is the skill that separates analysts. Here's the mental model — INNER vs LEFT, self-joins, and anti-joins. 🧵

**SEO keywords:** SQL JOIN, INNER JOIN, LEFT JOIN, self join, anti join, SQL joins explained, PostgreSQL joins, analyst skills
