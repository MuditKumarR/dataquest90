# 🧩 Mission 7 Quiz — Window Functions

Answers at the bottom.

---

**1.** Unlike `GROUP BY`, window functions:
- A) Collapse rows into groups
- B) Keep every row while adding aggregate context
- C) Cannot use aggregates
- D) Only work on one column

**2.** Which clause defines a window?
- A) `GROUP BY`
- B) `OVER (...)`
- C) `HAVING`
- D) `WINDOW BY`

**3.** `ROW_NUMBER()` produces:
- A) Ties share a rank with gaps
- B) Unique sequential numbers, no ties
- C) Ties share a rank, no gaps
- D) Random numbers

**4.** Difference between `RANK()` and `DENSE_RANK()`?
- A) None
- B) `RANK()` leaves gaps after ties; `DENSE_RANK()` does not
- C) `DENSE_RANK()` leaves gaps
- D) `RANK()` ignores ORDER BY

**5.** To rank salaries *within each department*, add:
- A) `OVER (ORDER BY salary)`
- B) `OVER (PARTITION BY department_id ORDER BY salary DESC)`
- C) `GROUP BY department_id`
- D) `OVER (department_id)`

**6.** `LAG(salary) OVER (ORDER BY hire_date)` returns:
- A) The next row's salary
- B) The previous row's salary
- C) The max salary
- D) A running total

**7.** A running total uses:
- A) `COUNT(*)`
- B) `SUM(x) OVER (ORDER BY ...)`
- C) `SUM(x) GROUP BY`
- D) `AVG(x) OVER ()`

**8.** `NTILE(5)` does what?
- A) Returns top 5 rows
- B) Splits rows into 5 equal buckets (bands)
- C) Multiplies by 5
- D) Ranks only 5 rows

---

## ✅ Answers
1-B · 2-B · 3-B · 4-B · 5-B · 6-B · 7-B · 8-B

**Score 6+?** Advance to [Mission 8](../MISSIONS/MISSION-08/README.md). See [Window Functions cheat sheet](../CHEATSHEETS/04-sql-window-functions.md).
