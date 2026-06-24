# 💼 SQL Interview Questions — 100 Core Questions with Answers

> Covers fundamentals through intermediate SQL. Every question includes an answer and explanation. PostgreSQL 17 syntax.

---

## A. Fundamentals (1–25)

**1. What is SQL?**
Structured Query Language — the standard language for managing and querying relational databases. It's declarative: you describe *what* you want, the engine decides *how*.

**2. Difference between SQL and a database?**
SQL is the language; a database (e.g. PostgreSQL) is the system that stores data and executes SQL.

**3. What are the main SQL command categories?**
DDL (CREATE/ALTER/DROP), DML (INSERT/UPDATE/DELETE), DQL (SELECT), DCL (GRANT/REVOKE), TCL (COMMIT/ROLLBACK).

**4. What does SELECT do?**
Retrieves rows from one or more tables. `SELECT col FROM table;`

**5. Difference between `WHERE` and `HAVING`?**
`WHERE` filters rows before grouping; `HAVING` filters groups after `GROUP BY`. `HAVING` can use aggregates, `WHERE` cannot.

**6. What is `DISTINCT`?**
Removes duplicate rows from results. `SELECT DISTINCT department_id FROM employees;`

**7. What does `ORDER BY` do? Default direction?**
Sorts the result set. Default is ascending (`ASC`); use `DESC` for descending.

**8. What is `LIMIT` / `OFFSET`?**
`LIMIT` caps rows returned; `OFFSET` skips rows — together they paginate.

**9. How do you alias a column?**
`SELECT salary AS monthly_pay FROM employees;` The `AS` keyword is optional.

**10. What is a NULL?**
The absence of a value. Not equal to 0 or empty string. Use `IS NULL` / `IS NOT NULL` (never `= NULL`).

**11. How do you handle NULLs in output?**
`COALESCE(phone, 'N/A')` returns the first non-NULL argument.

**12. What does `NULLIF(a,b)` do?**
Returns NULL if `a = b`, else `a`. Common to prevent division by zero: `x / NULLIF(y,0)`.

**13. Difference between `COUNT(*)` and `COUNT(column)`?**
`COUNT(*)` counts all rows; `COUNT(column)` counts non-NULL values in that column.

**14. What are the aggregate functions?**
`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`.

**15. What is `GROUP BY`?**
Groups rows sharing a value so aggregates compute per group.

**16. Why must non-aggregated SELECT columns appear in GROUP BY?**
Because the engine needs to know how to collapse rows — each output column must be either grouped or aggregated.

**17. What are the comparison operators?**
`=`, `<>`/`!=`, `<`, `>`, `<=`, `>=`.

**18. What is `BETWEEN`?**
Inclusive range filter: `WHERE salary BETWEEN 40000 AND 80000`.

**19. What is `IN`?**
Matches any value in a list: `WHERE department_id IN (1,2,3)`.

**20. Difference between `LIKE` and `ILIKE`?**
`LIKE` is case-sensitive pattern matching; `ILIKE` (PostgreSQL) is case-insensitive. `%` = any chars, `_` = one char.

**21. How do you concatenate strings in PostgreSQL?**
`first_name || ' ' || last_name` or `CONCAT(...)`.

**22. What does `CASE` do?**
Conditional logic in queries — like if/else. Returns a value based on conditions.

**23. What is the difference between `DELETE`, `TRUNCATE`, and `DROP`?**
`DELETE` removes rows (can filter, logged); `TRUNCATE` fast-empties a table; `DROP` removes the table entirely.

**24. What is a primary key?**
A column (or set) that uniquely identifies each row. Cannot be NULL or duplicated.

**25. What is a foreign key?**
A column referencing another table's primary key — enforces referential integrity.

---

## B. Joins (26–45)

**26. What is a JOIN?**
Combines rows from two or more tables based on a related column.

**27. Explain INNER JOIN.**
Returns only rows with matches in both tables.

**28. Explain LEFT JOIN.**
Returns all rows from the left table plus matching right rows (NULLs where no match).

**29. Explain RIGHT JOIN.**
All rows from the right table plus matching left rows.

**30. Explain FULL OUTER JOIN.**
All rows from both tables, matched where possible, NULLs elsewhere.

**31. What is a CROSS JOIN?**
Cartesian product — every combination of rows. M×N rows.

**32. What is a SELF JOIN?**
A table joined to itself, e.g. employees to their managers.

**33. How do you find rows in A with no match in B?**
`LEFT JOIN B ... WHERE B.key IS NULL` (anti-join).

**34. Difference between JOIN and UNION?**
JOIN combines columns horizontally (side by side); UNION stacks rows vertically.

**35. What is the ON clause?**
Specifies the join condition. Without it (except CROSS), you get errors or accidental products.

**36. Can you join on multiple columns?**
Yes: `ON a.x = b.x AND a.y = b.y`.

**37. What happens if you forget the join condition?**
You get a Cartesian product (every combination) — usually a bug.

**38. INNER vs LEFT JOIN for counting — which keeps zero-count groups?**
LEFT JOIN — it preserves rows with no match, so `COUNT` returns 0 instead of dropping them.

**39. What is a natural join? Should you use it?**
Joins automatically on same-named columns. Avoid it — implicit and fragile; be explicit with `ON`.

**40. What is a USING clause?**
Shorthand when join columns share a name: `JOIN departments USING (department_id)`.

**41. How do you join three+ tables?**
Chain JOINs: `FROM a JOIN b ON ... JOIN c ON ...`.

**42. What is a semi-join?**
Returns rows from A that have a match in B, without duplicating — typically via `EXISTS` or `IN`.

**43. Difference between `EXISTS` and `IN`?**
`EXISTS` checks for row existence (often faster, NULL-safe); `IN` checks membership in a list/subquery.

**44. What's a LATERAL join?**
A join where the right side can reference columns from the left — useful for per-row subqueries/top-N.

**45. How do you self-join to find pairs without duplicates?**
`JOIN ... ON a.id < b.id` to avoid mirror duplicates and self-pairs.

---

## C. Aggregations & Grouping (46–60)

**46. How do you count rows per group?**
`SELECT dept, COUNT(*) FROM t GROUP BY dept;`

**47. How do you filter aggregated results?**
`HAVING`, e.g. `HAVING COUNT(*) > 5`.

**48. What is `FILTER (WHERE ...)`?**
PostgreSQL conditional aggregate: `COUNT(*) FILTER (WHERE status='Active')`.

**49. How do you compute a percentage of total?**
`100.0 * COUNT(*) / SUM(COUNT(*)) OVER ()` — note `100.0` to force float math.

**50. Why does `1/2` return 0?**
Integer division. Use `1.0/2` or cast to numeric.

**51. How do you get the median?**
`PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY col)`.

**52. What is `STRING_AGG`?**
Concatenates values across a group: `STRING_AGG(name, ', ')`.

**53. What does `ROLLUP` do?**
Adds subtotals and a grand total to grouped results.

**54. Difference between `ROLLUP` and `CUBE`?**
`ROLLUP` gives hierarchical subtotals; `CUBE` gives all combinations of subtotals.

**55. How do you find the max value per group?**
`MAX(col)` with `GROUP BY`, or window function for the full row.

**56. How do you count distinct values?**
`COUNT(DISTINCT column)`.

**57. What's the difference between `AVG` and a manual `SUM/COUNT`?**
`AVG` ignores NULLs; `SUM/COUNT(*)` would include NULL rows in the denominator. Be careful.

**58. How do you pivot rows to columns?**
`COUNT(*) FILTER (WHERE category='A') AS a, ...` per category.

**59. Can you nest aggregates?**
Not directly (`SUM(COUNT(*))` errors without a window/subquery). Use a subquery or window.

**60. What is `MODE()`?**
`MODE() WITHIN GROUP (ORDER BY col)` returns the most frequent value.

---

## D. Subqueries & CTEs (61–75)

**61. What is a subquery?**
A query nested inside another query.

**62. Difference between correlated and non-correlated subquery?**
Correlated references the outer query (runs per row); non-correlated runs independently once.

**63. What is a CTE?**
Common Table Expression — a named temporary result with `WITH`, improves readability.

**64. CTE vs subquery — when to use CTE?**
For readability, reuse within a query, or recursion.

**65. What is a recursive CTE?**
A CTE that references itself — used for hierarchies (org charts, graphs, bill-of-materials).

**66. Write a query for the 2nd highest salary.**
`SELECT MAX(salary) FROM employees WHERE salary < (SELECT MAX(salary) FROM employees);`

**67. What is a derived table?**
A subquery in the FROM clause, treated as a temporary table.

**68. What does `EXISTS` return?**
TRUE/FALSE based on whether the subquery returns any rows.

**69. What is `NOT EXISTS` used for?**
Finding rows with no related rows (anti-join), e.g. customers with no orders.

**70. Can a subquery return multiple columns?**
Yes, in FROM (derived table) or with row comparisons; scalar subqueries return one value.

**71. What is a scalar subquery?**
A subquery returning a single value, usable anywhere a value is expected.

**72. How do CTEs help with recursion depth?**
The recursive term repeatedly joins back until no new rows — must have a terminating condition.

**73. Are CTEs materialized in PostgreSQL?**
Since PG12, they're inlined by default (can use `MATERIALIZED`/`NOT MATERIALIZED` to control).

**74. Difference between `IN` and `EXISTS` with NULLs?**
`NOT IN` with NULLs in the list returns no rows (NULL pitfall); `NOT EXISTS` is NULL-safe. Prefer `NOT EXISTS`.

**75. How do you reference a CTE multiple times?**
Just use its name multiple times in the main query — it's defined once.

---

## E. Window Functions (76–90)

**76. What is a window function?**
Computes across a set of rows related to the current row, without collapsing them.

**77. Difference between `ROW_NUMBER`, `RANK`, `DENSE_RANK`?**
`ROW_NUMBER`: unique 1,2,3. `RANK`: ties share, gaps follow (1,2,2,4). `DENSE_RANK`: ties share, no gaps (1,2,2,3).

**78. What does `PARTITION BY` do?**
Divides rows into groups for the window function (like GROUP BY but rows are retained).

**79. What are `LAG` and `LEAD`?**
Access previous/next row values — used for period-over-period comparisons.

**80. How do you compute a running total?**
`SUM(x) OVER (ORDER BY date)`.

**81. How do you compute a moving average?**
`AVG(x) OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)`.

**82. What is `NTILE`?**
Divides rows into N buckets (quartiles, deciles).

**83. Why does `LAST_VALUE` often return the current row?**
Default frame ends at current row. Add `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`.

**84. Can you use window functions in WHERE?**
No — wrap in a subquery/CTE then filter.

**85. How do you get top N per group?**
`ROW_NUMBER() OVER (PARTITION BY grp ORDER BY x DESC)` then filter `rn <= N`.

**86. What is the default window frame with ORDER BY?**
`RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`.

**87. Difference between `ROWS` and `RANGE` frames?**
`ROWS` counts physical rows; `RANGE` groups by value (ties treated together).

**88. What is `FIRST_VALUE` / `NTH_VALUE`?**
Return the first / nth value in the window frame.

**89. How do you deduplicate keeping the latest row?**
`ROW_NUMBER() OVER (PARTITION BY key ORDER BY updated_at DESC)` then keep `rn = 1`.

**90. What's `PERCENT_RANK`?**
Relative rank from 0 to 1 within the partition.

---

## F. Practical & Design (91–100)

**91. How do you find duplicate rows?**
`GROUP BY cols HAVING COUNT(*) > 1`.

**92. How do you delete duplicates keeping one?**
Self-join or `ROW_NUMBER` partitioned by the duplicate key, delete `rn > 1`.

**93. What is an index? When does it help?**
A data structure speeding lookups. Helps WHERE/JOIN/ORDER BY on indexed columns; costs write speed and storage.

**94. What is a transaction?**
A unit of work that's all-or-nothing — ACID (Atomicity, Consistency, Isolation, Durability).

**95. What does `RETURNING` do in PostgreSQL?**
Returns affected rows from INSERT/UPDATE/DELETE.

**96. What is an upsert? PostgreSQL syntax?**
Insert-or-update: `INSERT ... ON CONFLICT (key) DO UPDATE SET ...`.

**97. How do you paginate results?**
`ORDER BY ... LIMIT n OFFSET m` (or keyset pagination for large tables).

**98. What is normalization?**
Organizing tables to reduce redundancy (1NF/2NF/3NF). Denormalization trades redundancy for read speed.

**99. What is the difference between `UNION` and `UNION ALL`?**
`UNION` removes duplicates (slower); `UNION ALL` keeps all rows (faster).

**100. How would you optimize a slow query?**
Check `EXPLAIN ANALYZE`, add indexes on filter/join columns, avoid `SELECT *`, reduce scanned rows, update statistics, rewrite correlated subqueries as joins.

---

> Next: [Advanced SQL (50)](02-advanced-sql.md) · [PostgreSQL (50)](03-postgresql.md)
