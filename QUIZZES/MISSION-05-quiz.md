# 🧩 Mission 5 Quiz — Subqueries & EXISTS

Answers at the bottom.

---

**1.** A subquery that returns a single value is called:
- A) Correlated subquery
- B) Scalar subquery
- C) Derived table
- D) Set subquery

**2.** Which finds employees earning above the company average?
- A) `WHERE salary > AVG(salary)`
- B) `WHERE salary > (SELECT AVG(salary) FROM employees)`
- C) `HAVING salary > AVG(salary)`
- D) `WHERE salary > MAX(salary)`

**3.** A correlated subquery:
- A) Runs once for the whole query
- B) References the outer query and runs per row
- C) Cannot use WHERE
- D) Is the same as a JOIN

**4.** `EXISTS` returns true when the subquery:
- A) Returns at least one row
- B) Returns exactly one row
- C) Returns NULL
- D) Returns zero rows

**5.** To find employees who have NEVER had a performance review, use:
- A) `EXISTS`
- B) `NOT EXISTS`
- C) `IN`
- D) `HAVING`

**6.** A subquery used in the `FROM` clause is a:
- A) Scalar subquery
- B) Derived table
- C) Correlated subquery
- D) View

**7.** The `NOT IN` trap occurs when the subquery list contains:
- A) Duplicates
- B) NULL values (can make the whole result empty/unexpected)
- C) Zero rows
- D) Strings

**8.** Which finds the customer with the maximum lifetime_value?
- A) `WHERE lifetime_value = MAX(lifetime_value)`
- B) `WHERE lifetime_value = (SELECT MAX(lifetime_value) FROM customers)`
- C) `HAVING MAX(lifetime_value)`
- D) `ORDER BY lifetime_value`

---

## ✅ Answers
1-B · 2-B · 3-B · 4-A · 5-B · 6-B · 7-B · 8-B

**Score 6+?** Move to [Mission 6](../MISSIONS/MISSION-06/README.md).
