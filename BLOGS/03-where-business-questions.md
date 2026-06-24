# WHERE: How Databases Answer Business Questions

> **Level:** L1 (Junior Data Analyst) · **Reading time:** 6 minutes

---

## 🎣 The Hook

A database with a million rows is useless until you can say: *"Show me only the ones I care about."* That's `WHERE` — and it's where data turns into decisions.

---

## 💼 The Business Problem

The HR Director at DataVerse asks: *"Who are our active full-time employees in Engineering earning over $90K, and who's missing a phone number on file?"* Every clause of that sentence is a filter.

---

## 🧠 The Concept

`WHERE` filters rows. Combine conditions with `AND`/`OR`/`NOT`:

```sql
SELECT first_name, last_name, salary
FROM employees
WHERE department_id = 6
  AND status = 'Active'
  AND employment_type = 'Full-Time'
  AND salary > 90000;
```

The filtering toolkit:

```sql
WHERE department_id IN (4, 5, 6)              -- match a list
WHERE salary BETWEEN 60000 AND 90000          -- inclusive range
WHERE first_name LIKE 'J%'                     -- pattern (starts with J)
WHERE email ILIKE '%@dataverse%'               -- case-insensitive
WHERE phone IS NULL                            -- missing data
WHERE NOT status = 'Terminated'                -- negation
```

---

## ⚠️ The NULL Trap

`NULL` means "unknown," so `= NULL` never works:

```sql
-- WRONG: returns nothing
WHERE phone = NULL
-- RIGHT
WHERE phone IS NULL
```

This single misunderstanding causes countless silent bugs.

---

## 🔬 Why This Matters

Every business question is a filter. "Customers who churned." "Orders over $10K." "Employees hired this year." Learn `WHERE` deeply and you can translate any stakeholder request into a precise query.

---

## 🏋️ Try It Yourself

1. Find all employees hired in 2023.
2. List customers with no recorded NPS score.
3. Show products priced between $100 and $500.

→ Practice in [MISSION 2](../MISSIONS/MISSION-02/README.md).

---

## 🔗 References

- [Mission 2: HR Employee Insights](../MISSIONS/MISSION-02/README.md)
- [SQL Basics Cheat Sheet](../CHEATSHEETS/01-sql-basics.md)

---

## 📣 LinkedIn Summary

> Every business question is secretly a filter. "Active customers." "Orders over $10K." "Hired this year." That's the SQL `WHERE` clause — and mastering it (including the NULL trap that bites everyone) is how you turn data into decisions. 🧵

**SEO keywords:** SQL WHERE clause, SQL filtering, SQL NULL, IS NULL, SQL LIKE ILIKE, PostgreSQL WHERE, data analyst SQL
