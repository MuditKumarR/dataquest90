# 🚀 Advanced SQL Interview Questions — 50 Questions with Answers

> Complex queries, performance, advanced patterns. PostgreSQL 17.

---

## A. Advanced Query Patterns (1–20)

**1. How do you find the Nth highest salary generically?**
`SELECT DISTINCT salary FROM (SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) r FROM employees) x WHERE r = N;`

**2. Explain gaps-and-islands.**
A pattern to group consecutive sequences. Subtract `ROW_NUMBER()` from the value; equal differences form an "island" (consecutive group).

**3. How do you find consecutive login streaks?**
Compute `day - ROW_NUMBER() OVER (PARTITION BY user ORDER BY day)`; equal results = same streak; group by it.

**4. How do you pivot dynamically?**
PostgreSQL has no native dynamic pivot; use `crosstab` (tablefunc extension) or build SQL dynamically in application code.

**5. How do you unpivot (columns → rows)?**
Use `UNION ALL` per column, or `LATERAL (VALUES ...)`.

**6. Write a query for cumulative percentage (running share).**
`SUM(x) OVER (ORDER BY x DESC) / SUM(x) OVER ()` gives running cumulative share.

**7. How do you find median per group?**
`PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY x)` with `GROUP BY grp`.

**8. How do you compute month-over-month growth?**
`(rev - LAG(rev) OVER (ORDER BY month)) / NULLIF(LAG(rev) OVER (ORDER BY month),0)`.

**9. How do you find the first order per customer?**
`DISTINCT ON (customer_id) ... ORDER BY customer_id, order_date` (PostgreSQL) or `ROW_NUMBER`.

**10. What is `DISTINCT ON`?**
PostgreSQL feature returning the first row per specified column(s) given an ORDER BY.

**11. How do you calculate retention cohorts?**
Group users by signup period, then count active users in each subsequent period as a fraction of the cohort.

**12. How do you find overlapping date ranges?**
`WHERE a.start <= b.end AND b.start <= a.end`.

**13. How do you sample random rows efficiently?**
`TABLESAMPLE SYSTEM (1)` for approximate; `ORDER BY random() LIMIT n` for exact but slow.

**14. How do you generate a date series?**
`generate_series('2024-01-01'::date, '2024-12-31', '1 day')`.

**15. How do you fill gaps in time series?**
LEFT JOIN a `generate_series` calendar to your data so missing dates show as NULL/0.

**16. How do you compute a 7-day rolling sum?**
`SUM(x) OVER (ORDER BY day RANGE BETWEEN INTERVAL '6 days' PRECEDING AND CURRENT ROW)`.

**17. What is a window frame and why does it matter?**
Defines which rows the function sees relative to the current row — controls running vs moving calculations.

**18. How do you rank within multiple dimensions?**
Multiple `PARTITION BY` columns in the OVER clause.

**19. How do you find the top product per category by revenue?**
`ROW_NUMBER() OVER (PARTITION BY category ORDER BY revenue DESC)` then `= 1`.

**20. How do you compute year-to-date totals?**
`SUM(x) OVER (PARTITION BY year ORDER BY date)`.

---

## B. Performance & Optimization (21–35)

**21. What does `EXPLAIN` show?**
The query execution plan — how the planner intends to run the query (scans, joins, costs).

**22. Difference between `EXPLAIN` and `EXPLAIN ANALYZE`?**
`ANALYZE` actually runs the query and shows real timing/row counts.

**23. What is a sequential scan vs index scan?**
Seq scan reads the whole table; index scan uses an index to find rows. Seq scan is fine for small tables or low selectivity.

**24. When should you NOT add an index?**
On small tables, low-cardinality columns, or write-heavy tables where index maintenance hurts.

**25. What is a composite index? Column order matters?**
An index on multiple columns. Order matters — it helps queries filtering on a left-prefix of the columns.

**26. What is a covering index?**
An index that includes all columns a query needs (`INCLUDE`), avoiding a table lookup.

**27. What is index selectivity?**
The fraction of distinct values. High selectivity (many distinct) = more useful index.

**28. Why avoid `SELECT *`?**
Fetches unneeded columns, increases I/O, breaks covering indexes, and is fragile to schema changes.

**29. How do functions on columns hurt indexes?**
`WHERE UPPER(name)='X'` can't use a normal index on `name`. Use a functional index or rewrite.

**30. What is a partial index?**
An index with a WHERE clause, indexing only relevant rows: `CREATE INDEX ON orders(id) WHERE status='Active'`.

**31. How does `VACUUM` help performance?**
Reclaims space from dead tuples and updates visibility maps; `ANALYZE` refreshes planner statistics.

**32. What causes a query plan to go bad after data growth?**
Stale statistics. Run `ANALYZE`; the planner may switch from index to seq scan or vice versa.

**33. What is table partitioning? When use it?**
Splitting a large table into partitions (by range/list/hash). Use for very large tables to prune scans and ease maintenance.

**34. How do you optimize a correlated subquery?**
Often rewrite as a JOIN or use a window function to avoid per-row execution.

**35. What are common causes of slow joins?**
Missing indexes on join keys, type mismatches preventing index use, exploding cardinality, and outdated stats.

---

## C. Advanced Concepts (36–50)

**36. What is a materialized view?**
A view whose results are stored physically; refreshed on demand with `REFRESH MATERIALIZED VIEW`. Faster reads, stale data.

**37. View vs materialized view?**
A view is a stored query (always fresh, computed each time); a materialized view caches results (fast but stale until refreshed).

**38. What are transaction isolation levels?**
Read Uncommitted, Read Committed (PG default), Repeatable Read, Serializable — increasing protection against anomalies.

**39. What anomalies do isolation levels prevent?**
Dirty reads, non-repeatable reads, phantom reads. Serializable prevents all.

**40. What is a deadlock? How to avoid?**
Two transactions waiting on each other's locks. Avoid by acquiring locks in a consistent order and keeping transactions short.

**41. What is MVCC?**
Multi-Version Concurrency Control — readers see a snapshot, writers create new versions, so reads don't block writes. PostgreSQL core mechanism.

**42. What is the difference between `MERGE` and `INSERT ON CONFLICT`?**
Both upsert. `MERGE` (PG15+) is SQL-standard and handles INSERT/UPDATE/DELETE in one statement; `ON CONFLICT` is PostgreSQL-specific and simpler.

**43. What is a CTE's role in recursion vs iteration?**
Recursive CTEs replace procedural loops for hierarchical/graph traversal declaratively.

**44. How do you implement SCD Type 2?**
Add `valid_from`, `valid_to`, `is_current`; on change, expire the current row and insert a new version.

**45. What is a window function frame's effect on percentiles?**
Percentile/aggregate windows respect the frame; an explicit full frame is needed for whole-partition results.

**46. What is `GROUPING SETS`?**
Lets you define multiple groupings in one query (combine several `GROUP BY` results).

**47. How do you handle JSONB querying and indexing?**
Use `->`, `->>`, `@>` operators; index with GIN for containment queries.

**48. What is a LATERAL join good for?**
Running a subquery per outer row — e.g. top-3 orders per customer.

**49. How do you detect and remove duplicates at scale?**
`ROW_NUMBER()` partitioned by the dedup key, delete where `rn > 1`; ensure an index supports the ordering.

**50. How do you design for query performance from the start?**
Right data types, proper keys/indexes, appropriate normalization, partition large tables, pre-aggregate hot queries, and test with realistic data volumes.

---

> Next: [PostgreSQL (50)](03-postgresql.md) · [Data Engineering (50)](04-data-engineering.md)
