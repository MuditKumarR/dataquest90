# 🧩 Mission 6 Quiz — CTEs, Views & Materialized Views

Answers at the bottom.

---

**1.** A CTE is defined with which keyword?
- A) `CREATE`
- B) `WITH`
- C) `DEFINE`
- D) `LET`

**2.** The main benefit of a CTE over a nested subquery is:
- A) Always faster
- B) Readability — name and reuse a result set
- C) Uses less storage
- D) Required for joins

**3.** Which keyword makes a CTE recursive?
- A) `WITH LOOP`
- B) `WITH RECURSIVE`
- C) `RECURSE`
- D) `WITH SELF`

**4.** Recursive CTEs are ideal for:
- A) Simple filtering
- B) Hierarchies like org charts (employee → manager)
- C) Aggregation only
- D) Sorting

**5.** A recursive CTE consists of:
- A) Only one SELECT
- B) An anchor member + a recursive member joined by UNION ALL
- C) Two JOINs
- D) A WHERE and HAVING

**6.** A regular `VIEW`:
- A) Stores its result physically
- B) Stores the query and runs it fresh each time (always current)
- C) Cannot be queried
- D) Is faster than a table always

**7.** A `MATERIALIZED VIEW`:
- A) Always reflects live data instantly
- B) Caches the result physically and must be refreshed
- C) Cannot be indexed
- D) Is the same as a regular view

**8.** To update a materialized view's stored data you run:
- A) `UPDATE VIEW`
- B) `REFRESH MATERIALIZED VIEW`
- C) `RECOMPUTE`
- D) `ALTER VIEW`

---

## ✅ Answers
1-B · 2-B · 3-B · 4-B · 5-B · 6-B · 7-B · 8-B

**Score 6+?** Continue to [Mission 7](../MISSIONS/MISSION-07/README.md).
