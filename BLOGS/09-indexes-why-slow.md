# Indexes: Why Your Query Is Slow

> **Level:** L4 (Data Engineer) · **Reading time:** 8 minutes

---

## 🎣 The Hook

Your query worked fine on 1,000 rows. Now there are 10 million and it takes 40 seconds. Welcome to the moment every data professional hits — and the answer is almost always **indexes**.

---

## 💼 The Business Problem

DataVerse's dashboards have ground to a halt. The CTO is furious: *"Reports that took 2 seconds now take 2 minutes. Fix it."* No new hardware. No rewrite. Just understanding how the database finds data.

---

## 🧠 The Concept

Without an index, the database does a **sequential scan** — it reads every row to find matches. An index is like a book's index: it lets the database jump straight to what it needs.

```sql
-- Slow: scans all employees
SELECT * FROM employees WHERE email = 'jrichardson@dataverse.com';

-- Create an index
CREATE INDEX idx_employees_email ON employees(email);

-- Now: index lookup, near-instant
```

### Composite Indexes (order matters)

```sql
CREATE INDEX idx_orders_cust_date ON orders(customer_id, order_date);
```

This helps queries filtering on `customer_id` (and optionally `order_date`), but **not** ones filtering only on `order_date` — indexes work left-to-right.

### Functional Indexes

```sql
-- WHERE LOWER(email) = '...' can't use a normal email index
CREATE INDEX idx_email_lower ON employees(LOWER(email));
```

### Partial Indexes

```sql
-- Index only the rows you query often
CREATE INDEX idx_active_orders ON orders(order_date) WHERE status = 'Active';
```

---

## ⚖️ The Trade-Off

Indexes aren't free:

| Benefit | Cost |
|---------|------|
| Faster reads | Slower writes (index maintenance) |
| Faster JOINs | Extra storage |
| Faster ORDER BY | Must be maintained on updates |

**Don't** index everything. Index columns used in `WHERE`, `JOIN`, and `ORDER BY` on large tables.

---

## 🔍 When Indexes Don't Help

- Tiny tables (seq scan is faster).
- Low selectivity (e.g. a boolean — half the rows match).
- Functions on the column (without a functional index).
- Leading wildcards: `LIKE '%text'` can't use a normal B-tree.

---

## 🏋️ Try It Yourself

1. Create an index on `orders(customer_id)` and compare `EXPLAIN` before/after.
2. Build a composite index for a two-column filter.
3. Create a partial index for active records only.

→ Practice in [MISSION 9](../MISSIONS/MISSION-09/README.md).

---

## 🔗 References

- [Mission 9: Database Performance Crisis](../MISSIONS/MISSION-09/README.md)
- [PostgreSQL Commands Cheat Sheet](../CHEATSHEETS/06-postgresql-commands.md)

---

## 📣 LinkedIn Summary

> Your query was fast on 1K rows. Now it's 10M rows and takes 40 seconds. Every data engineer hits this wall — and the answer is almost always indexes. Here's how they work, when they help, and the trade-offs nobody warns you about. 👇

**SEO keywords:** SQL index, database performance, composite index, partial index, sequential scan, query optimization, PostgreSQL index, slow query
