# Slowly Changing Dimensions Explained

> **Level:** L7 (Data Architect) · **Reading time:** 8 minutes

---

## 🎣 The Hook

A customer moves from "Mid-Market" to "Enterprise." Do you overwrite the old value and lose history? Or keep both so last year's reports still make sense? This question — how dimensions change over time — is one of the most important (and most botched) decisions in data warehousing. It has a name: **Slowly Changing Dimensions**.

---

## 💼 The Business Problem

DataVerse's finance team runs a report: *"Revenue by customer segment, 2023 vs 2024."* But customers changed segments during that time. If you only store today's segment, your historical numbers are wrong. SCD solves this.

---

## 🧠 The Concept

### SCD Type 1 — Overwrite (no history)

```sql
UPDATE dim_customer SET segment = 'Enterprise' WHERE customer_id = 5;
```

Simple, but you lose the past. Use when history doesn't matter (e.g. fixing a typo).

### SCD Type 2 — New Row Per Change (full history)

The gold standard. Add validity columns and create a new row each time something changes:

```sql
ALTER TABLE dim_customer
    ADD COLUMN valid_from DATE DEFAULT CURRENT_DATE,
    ADD COLUMN valid_to   DATE DEFAULT '9999-12-31',
    ADD COLUMN is_current BOOLEAN DEFAULT TRUE;

-- Customer 5 changes segment:
-- 1. Expire the current row
UPDATE dim_customer
SET valid_to = CURRENT_DATE, is_current = FALSE
WHERE customer_id = 5 AND is_current;

-- 2. Insert the new version
INSERT INTO dim_customer (customer_id, company_name, segment, valid_from, is_current)
VALUES (5, 'TechCorp', 'Enterprise', CURRENT_DATE, TRUE);
```

Now every fact row joins to the dimension row that was *current at the time of the event* — historical reports stay accurate.

### SCD Type 3 — Previous Value Column (limited history)

```sql
ALTER TABLE dim_customer ADD COLUMN previous_segment VARCHAR(50);
```

Keeps only the prior value. Rare.

---

## 🔑 The Surrogate Key Connection

SCD2 is *why* warehouses use surrogate keys. The same `customer_id` (business key) can have multiple rows (versions), each with a unique `customer_key` (surrogate). Facts point to the specific version.

```sql
-- Revenue by the segment that was active AT THE TIME of each sale
SELECT dc.segment, SUM(fs.revenue)
FROM fact_sales fs
JOIN dim_customer dc ON fs.customer_key = dc.customer_key  -- specific version
GROUP BY dc.segment;
```

---

## 🧭 Choosing a Type

| Need | Type |
|------|------|
| History doesn't matter | Type 1 |
| Full point-in-time accuracy | Type 2 |
| Just the previous value | Type 3 |

Most important dimensions (customer, product, employee) use **Type 2**.

---

## 🏋️ Try It Yourself

1. Add SCD2 columns to a dimension and simulate a change.
2. Write a query showing a customer's full segment history.
3. Join a fact to the version that was current at the event date.

→ Practice in [MISSION 10](../MISSIONS/MISSION-10/README.md).

---

## 🔗 References

- [Mission 10: Data Warehouse Design](../MISSIONS/MISSION-10/README.md)
- [Data Warehouse SQL Cheat Sheet](../CHEATSHEETS/07-data-warehouse-sql.md)

---

## 📣 LinkedIn Summary

> A customer moves from Mid-Market to Enterprise. Do you overwrite the old value (and break last year's reports) or keep both? This is Slowly Changing Dimensions — one of the most important and most botched decisions in data warehousing. Here's Type 1, 2, and 3 explained. 👇

**SEO keywords:** slowly changing dimensions, SCD type 2, data warehouse, surrogate key, dimensional modeling, historical data, data architect, SCD explained
