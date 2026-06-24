# 🎯 MISSION 05 — Marketing Customer Intelligence

```
┌────────────────────────────────────────────────────────────────────┐
│  LEVEL 3: Analytics Engineer                                       │
│  XP AVAILABLE: 700                                                │
│  CONCEPTS: Subqueries · Correlated Subqueries · Nested Queries    │
│            · EXISTS · NOT EXISTS                                   │
│  ESTIMATED TIME: 70 minutes                                       │
└────────────────────────────────────────────────────────────────────┘
```

---

## 📧 The Brief

> **From:** Matthew Turner (Marketing Director)
> **To:** You (Analytics Engineer)
> **Subject:** Customer segmentation for Q3 campaign
>
> *"We're planning a major campaign and need smart targeting:*
>
> *- Which customers spend MORE than the average customer?*
> *- Which customers have placed at least one order? (and which haven't?)*
> *- For each customer, how does their spend compare to others in their industry?*
>
> *I keep hearing the data team mention 'subqueries' and 'EXISTS'. Can you use those?*
>
> *— Matthew"*

---

## 🧭 Why This Matters (The Real World)

Subqueries let you answer questions that depend on **other questions**. They are "a query inside a query."

> "Find customers who spend more than average" requires first calculating the average, *then* comparing. That's a subquery.

| Role | How they use subqueries |
|------|--------------------------|
| **Analyst** | "Above/below average" comparisons |
| **Data Engineer** | Filtering against lookup sets |
| **Analytics Engineer** | Building layered metric logic |
| **AI Engineer** | Selecting records meeting complex criteria |

---

## 📚 Concept 1 — Scalar Subquery (returns one value)

A subquery in the `WHERE` clause that returns a **single value**.

```sql
-- Customers whose lifetime_value is above the company average
SELECT 
    company_name,
    lifetime_value
FROM customers
WHERE lifetime_value > (
    SELECT AVG(lifetime_value) FROM customers
)
ORDER BY lifetime_value DESC;
```

The inner query `(SELECT AVG(lifetime_value) FROM customers)` runs first, produces one number, then the outer query compares against it.

```sql
-- The highest-paid employee
SELECT first_name, last_name, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);
```

---

## 📚 Concept 2 — Subquery with IN (returns a list)

When the subquery returns **multiple values**, use `IN`.

```sql
-- Customers who have placed at least one order
SELECT company_name
FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id FROM orders
);
```

```sql
-- Customers who have NOT placed any order
SELECT company_name
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id FROM orders WHERE customer_id IS NOT NULL
);
```

> ⚠️ **Always add `WHERE customer_id IS NOT NULL`** inside a `NOT IN` subquery. If a NULL sneaks in, `NOT IN` returns zero rows — a notorious bug.

---

## 📚 Concept 3 — Subquery in FROM (derived table)

A subquery can act as a temporary table you query from.

```sql
-- Average order value per customer, then filter
SELECT customer_id, total_spent
FROM (
    SELECT 
        customer_id,
        SUM(line_total) AS total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY customer_id
) AS customer_totals
WHERE total_spent > 100000
ORDER BY total_spent DESC;
```

The inner query builds a result set; the outer query treats it like a table. (In Mission 06 you'll learn CTEs, a cleaner way to do this.)

---

## 📚 Concept 4 — Correlated Subquery

A subquery that **references the outer query** — it runs once per outer row.

```sql
-- Each customer compared to the average spend IN THEIR INDUSTRY
SELECT 
    c1.company_name,
    c1.industry,
    c1.lifetime_value
FROM customers c1
WHERE c1.lifetime_value > (
    SELECT AVG(c2.lifetime_value)
    FROM customers c2
    WHERE c2.industry = c1.industry   -- correlation!
);
```

The inner query depends on `c1.industry` from the outer query. For each customer, it recalculates the average for *that customer's industry*. This answers Matthew's hardest question.

> 💡 Correlated subqueries are powerful but can be slow on large tables. Window functions (Mission 07) often replace them more efficiently.

---

## 📚 Concept 5 — EXISTS and NOT EXISTS

`EXISTS` checks whether a subquery returns **any rows at all**. It's often faster than `IN`.

```sql
-- Customers who have placed at least one order (using EXISTS)
SELECT c.company_name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

`SELECT 1` is a convention — EXISTS only cares *whether* rows exist, not what's in them.

```sql
-- Customers who have NEVER ordered (using NOT EXISTS)
SELECT c.company_name, c.customer_status
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

### EXISTS vs IN — Which to Use?

| Use Case | Prefer |
|----------|--------|
| Subquery returns a small, simple list | `IN` |
| Subquery is correlated / checks existence | `EXISTS` |
| Risk of NULLs in the subquery | `EXISTS` (NULL-safe) |
| Large datasets | `EXISTS` (often faster) |

`NOT EXISTS` is the **safe** way to find non-matches — it never has the NULL problem that `NOT IN` does.

---

## ✅ Solving Marketing's Request

```sql
-- 1. Customers spending above average
SELECT company_name, lifetime_value
FROM customers
WHERE lifetime_value > (SELECT AVG(lifetime_value) FROM customers)
ORDER BY lifetime_value DESC;

-- 2. Customers who have ordered
SELECT company_name FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

-- 2b. Customers who have NOT ordered (campaign targets!)
SELECT company_name FROM customers c
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

-- 3. Customers above their industry average
SELECT c1.company_name, c1.industry, c1.lifetime_value
FROM customers c1
WHERE c1.lifetime_value > (
    SELECT AVG(c2.lifetime_value) FROM customers c2
    WHERE c2.industry = c1.industry
)
ORDER BY c1.industry, c1.lifetime_value DESC;
```

---

## 🏋️ Exercises

1. Find employees who earn more than the company-wide average salary.
2. Find all products whose `unit_price` is above the average product price.
3. Find customers in the `'Enterprise'` segment whose `lifetime_value` exceeds the average lifetime_value of all Enterprise customers (correlated).
4. Using `EXISTS`, find all employees who have at least one performance review.
5. Using `NOT EXISTS`, find all employees who have **never** had a performance review.
6. Find departments (by `department_id`) that have at least one employee earning over $200K (use `IN` or `EXISTS`).
7. Find the customer(s) with the maximum `lifetime_value` using a scalar subquery.
8. Find products that have never appeared in `order_items` using `NOT EXISTS`.

→ Solutions: [SOLUTIONS/MISSION-05.md](../../SOLUTIONS/MISSION-05.md)

---

## 🧪 Quiz

→ [QUIZZES/MISSION-05-quiz.md](../../QUIZZES/MISSION-05-quiz.md)

---

## 🔥 Challenge (Bonus 100 XP)

> Matthew asks: *"Find our 'hidden gem' customers: companies whose lifetime_value is above their industry average BUT who have placed fewer than 2 orders. These are high-value accounts we're under-serving."*

**Hints:** Combine a correlated subquery (industry average) with a subquery counting orders per customer.

---

## 🎓 What You Learned

```
✓ Scalar subqueries — return one value
✓ IN subqueries — return a list
✓ NOT IN and the NULL trap
✓ Derived tables — subquery in FROM
✓ Correlated subqueries — reference the outer query
✓ EXISTS — check if rows exist
✓ NOT EXISTS — the safe anti-join
✓ EXISTS vs IN — when to use each
```

**XP EARNED: 700** (+100 bonus for the challenge)

---

## ➡️ Next Mission

The engineering team is drowning in copy-pasted queries. Time to make reusable logic...

→ [MISSION 06 — Data Team Needs Reusable Logic](../MISSION-06/README.md)
