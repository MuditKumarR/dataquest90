# 🧩 Mission 3 Quiz — Aggregations & GROUP BY

Answers at the bottom.

---

**1.** Which function counts rows?
- A) `SUM()`
- B) `COUNT()`
- C) `TOTAL()`
- D) `ADD()`

**2.** `COUNT(column)` vs `COUNT(*)` — the difference?
- A) No difference
- B) `COUNT(column)` ignores NULLs in that column
- C) `COUNT(*)` ignores NULLs
- D) `COUNT(column)` is faster always

**3.** Which clause filters *groups* (after aggregation)?
- A) WHERE
- B) HAVING
- C) FILTER
- D) GROUP

**4.** Average salary per department:
- A) `SELECT AVG(salary) FROM employees;`
- B) `SELECT department_id, AVG(salary) FROM employees GROUP BY department_id;`
- C) `SELECT department_id, AVG(salary) FROM employees;`
- D) `SELECT AVG(department_id) FROM employees GROUP BY salary;`

**5.** With `GROUP BY department_id`, which can appear unaggregated in SELECT?
- A) Any column
- B) Only `department_id`
- C) `salary`
- D) `first_name`

**6.** Departments with more than 5 employees:
- A) `... GROUP BY department_id WHERE COUNT(*) > 5`
- B) `... GROUP BY department_id HAVING COUNT(*) > 5`
- C) `... WHERE COUNT(*) > 5 GROUP BY department_id`
- D) `... HAVING department_id > 5`

**7.** Which ignores NULLs automatically?
- A) Only COUNT(*)
- B) Aggregate functions like SUM, AVG, MAX
- C) ORDER BY
- D) None

**8.** Total revenue across all sales:
- A) `SELECT COUNT(revenue) FROM sales_transactions;`
- B) `SELECT SUM(revenue) FROM sales_transactions;`
- C) `SELECT revenue FROM sales_transactions;`
- D) `SELECT AVG(revenue) GROUP BY revenue;`

---

## ✅ Answers
1-B · 2-B · 3-B · 4-B · 5-B · 6-B · 7-B · 8-B

**Score 6+?** Advance to [Mission 4](../MISSIONS/MISSION-04/README.md).
