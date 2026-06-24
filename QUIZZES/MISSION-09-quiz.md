# 🧩 Mission 9 Quiz — Performance, Indexes & EXPLAIN

Answers at the bottom.

---

**1.** An index primarily improves:
- A) Insert speed
- B) Read/lookup speed
- C) Storage size
- D) Backup speed

**2.** Which command shows a query's execution plan with real timings?
- A) `DESCRIBE`
- B) `EXPLAIN ANALYZE`
- C) `SHOW PLAN`
- D) `PROFILE`

**3.** A "Seq Scan" on a large table in EXPLAIN usually means:
- A) Optimal performance
- B) No useful index — full table read
- C) The table is empty
- D) A syntax error

**4.** Indexes slow down which operations?
- A) SELECT
- B) INSERT/UPDATE/DELETE (writes)
- C) ORDER BY
- D) JOIN

**5.** Best index candidate?
- A) A column never queried
- B) A column frequently used in WHERE/JOIN with high selectivity
- C) A boolean with two values
- D) A free-text notes column

**6.** A composite index on `(department_id, salary)` helps queries that filter:
- A) Only by salary
- B) By department_id, or department_id + salary (leftmost prefix)
- C) Any random column
- D) Never

**7.** `ANALYZE` updates:
- A) Indexes
- B) Planner statistics for better query plans
- C) Permissions
- D) Backups

**8.** Why not index every column?
- A) It's illegal
- B) Indexes consume storage and slow writes
- C) Indexes break joins
- D) Postgres allows only one index

---

## ✅ Answers
1-B · 2-B · 3-B · 4-B · 5-B · 6-B · 7-B · 8-B

**Score 6+?** Advance to [Mission 10](../MISSIONS/MISSION-10/README.md). See [Indexes blog](../BLOGS/09-indexes-why-slow.md).
