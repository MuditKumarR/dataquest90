# 🧩 Mission 1 Quiz — First Day at DataVerse (SELECT & WHERE)

Test your recall before moving on. Answers at the bottom.

---

**1.** Which clause filters rows *before* grouping?
- A) HAVING
- B) WHERE
- C) ORDER BY
- D) LIMIT

**2.** What does `SELECT *` return?
- A) Only the primary key
- B) All columns
- C) The first row
- D) A count of rows

**3.** Which query returns only Active employees?
- A) `SELECT * FROM employees HAVING status = 'Active';`
- B) `SELECT * FROM employees WHERE status = 'Active';`
- C) `SELECT * FROM employees WHERE status = Active;`
- D) `SELECT Active FROM employees;`

**4.** How do you find employees with no manager?
- A) `WHERE manager_id = 0`
- B) `WHERE manager_id = NULL`
- C) `WHERE manager_id IS NULL`
- D) `WHERE manager_id = ''`

**5.** Which operator matches a pattern like emails ending in `@dataverse.com`?
- A) `=`
- B) `LIKE '%@dataverse.com'`
- C) `IN`
- D) `BETWEEN`

**6.** What does `LIMIT 5` do?
- A) Returns rows 5 and up
- B) Returns at most 5 rows
- C) Skips 5 rows
- D) Returns column 5

**7.** Which finds salaries between 50000 and 80000 inclusive?
- A) `WHERE salary > 50000 AND salary < 80000`
- B) `WHERE salary BETWEEN 50000 AND 80000`
- C) `WHERE salary IN (50000, 80000)`
- D) `WHERE salary = 50000 OR 80000`

**8.** Why does `WHERE` reject a column alias defined in `SELECT`?
- A) Aliases are case-sensitive
- B) WHERE runs before SELECT in logical order
- C) Aliases only work in Snowflake
- D) It's a syntax error in all databases

---

## ✅ Answers
1-B · 2-B · 3-B · 4-C · 5-B · 6-B · 7-B · 8-B

**Score 6+?** Move to [Mission 2](../MISSIONS/MISSION-02/README.md). Below 6? Revisit [Mission 1](../MISSIONS/MISSION-01/README.md).
