# 🧩 Mission 4 Quiz — JOINs

Answers at the bottom.

---

**1.** Which join returns only matching rows from both tables?
- A) LEFT JOIN
- B) INNER JOIN
- C) FULL JOIN
- D) CROSS JOIN

**2.** You want ALL employees, even those without a department. Use:
- A) INNER JOIN
- B) LEFT JOIN (employees on the left)
- C) RIGHT JOIN
- D) CROSS JOIN

**3.** A `CROSS JOIN` produces:
- A) Only matches
- B) The Cartesian product (every combination)
- C) NULLs only
- D) A single row

**4.** Joining employees to their managers (same table) is a:
- A) Cross join
- B) Self join
- C) Full join
- D) Natural join

**5.** What does a LEFT JOIN put in right-table columns when there's no match?
- A) 0
- B) NULL
- C) Empty string
- D) The row is dropped

**6.** Correct syntax to join orders and customers?
- A) `FROM orders JOIN customers WHERE id`
- B) `FROM orders o JOIN customers c ON o.customer_id = c.customer_id`
- C) `FROM orders, customers JOIN`
- D) `FROM orders ON customers`

**7.** To find employees with NO orders, you'd use a LEFT JOIN and then:
- A) `WHERE orders.id = 0`
- B) `WHERE orders.id IS NULL`
- C) `HAVING orders.id`
- D) `INNER JOIN` instead

**8.** Why qualify columns (e.g., `e.department_id`) in joins?
- A) Performance
- B) To resolve ambiguity when both tables share a column name
- C) Required by Snowflake only
- D) It's optional decoration

---

## ✅ Answers
1-B · 2-B · 3-B · 4-B · 5-B · 6-B · 7-B · 8-B

**Score 6+?** Proceed to [Mission 5](../MISSIONS/MISSION-05/README.md). See also [Join Types diagram](../DIAGRAMS/join-types.md).
