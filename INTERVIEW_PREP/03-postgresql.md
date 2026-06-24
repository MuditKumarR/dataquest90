# 🐘 PostgreSQL Interview Questions — 50 Questions with Answers

> PostgreSQL-specific features, internals, and administration.

---

## A. PostgreSQL Features (1–20)

**1. What makes PostgreSQL different from MySQL?**
PostgreSQL is more standards-compliant, has richer types (JSONB, arrays, ranges), advanced indexing (GIN, GiST, BRIN), true MVCC, extensibility, and stronger concurrency.

**2. What is JSONB? Difference from JSON?**
`JSONB` stores binary, decomposed JSON — faster to query and indexable. `JSON` stores raw text, preserves formatting/order but slower.

**3. How do you query JSONB?**
`data->>'key'` (text), `data->'key'` (json), `data @> '{"k":1}'` (contains), `data#>>'{a,b}'` (path).

**4. What index type for JSONB?**
GIN index: `CREATE INDEX ON t USING gin(data);`.

**5. What are arrays in PostgreSQL?**
Native multi-value columns: `INTEGER[]`. Query with `ANY`, `unnest()`, `@>`.

**6. What is `generate_series`?**
A set-returning function producing sequences of numbers/dates — great for calendars and test data.

**7. What is `DISTINCT ON`?**
PostgreSQL extension returning the first row per group given an ORDER BY.

**8. What is `RETURNING`?**
Returns rows affected by INSERT/UPDATE/DELETE — get generated IDs without a second query.

**9. What is `ON CONFLICT`?**
Upsert clause: `INSERT ... ON CONFLICT (key) DO UPDATE/NOTHING`.

**10. What are generated columns?**
Computed columns: `GENERATED ALWAYS AS (qty*price) STORED`.

**11. What is `ILIKE`?**
Case-insensitive `LIKE`.

**12. What are CTEs and are they optimized?**
`WITH` queries; since PG12 inlined by default (controllable with `MATERIALIZED`).

**13. What window function features are PostgreSQL-specific?**
Full SQL-standard window support plus `FILTER`, custom frames, and ordered-set aggregates.

**14. What is a range type?**
A type representing a range of values (`int4range`, `tsrange`) with operators for overlap/containment.

**15. What is `LATERAL`?**
Allows a subquery in FROM to reference earlier FROM items — per-row subqueries.

**16. What are PostgreSQL extensions? Examples?**
Pluggable modules: `pgvector` (embeddings), `postgis` (geo), `pg_trgm` (fuzzy text), `tablefunc` (crosstab), `pg_stat_statements`.

**17. What is `pg_stat_statements`?**
An extension tracking query execution statistics — essential for finding slow queries.

**18. What full-text search does PostgreSQL offer?**
`tsvector`/`tsquery` types with `@@` match operator and GIN indexing.

**19. What is `pg_trgm`?**
Trigram extension for fuzzy/similarity matching and accelerating `LIKE '%x%'`.

**20. What are domains in PostgreSQL?**
Custom types with constraints, e.g. a `positive_int` domain reused across tables.

---

## B. Indexing & Internals (21–35)

**21. What index types does PostgreSQL support?**
B-tree (default), Hash, GIN, GiST, SP-GiST, BRIN.

**22. When use a GIN index?**
For multi-value columns: JSONB, arrays, full-text search.

**23. When use a BRIN index?**
For very large tables with naturally ordered data (e.g. timestamps) — tiny and fast for range scans.

**24. What is MVCC in PostgreSQL?**
Multi-Version Concurrency Control: each transaction sees a snapshot; updates create new row versions, so readers never block writers.

**25. What are dead tuples and why VACUUM?**
Old row versions left by updates/deletes. `VACUUM` reclaims their space and prevents bloat.

**26. What is autovacuum?**
A background process that automatically vacuums and analyzes tables based on activity thresholds.

**27. What is transaction ID wraparound?**
PostgreSQL's 32-bit transaction IDs can wrap; VACUUM freezes old rows to prevent data loss. Critical to keep autovacuum healthy.

**28. What is TOAST?**
The Oversized-Attribute Storage Technique — stores large field values out-of-line/compressed.

**29. What is a partial index?**
Indexes only rows matching a condition — smaller and faster for targeted queries.

**30. What is a covering index (`INCLUDE`)?**
B-tree index storing extra non-key columns so queries get all data from the index (index-only scan).

**31. What is an index-only scan?**
When all needed columns are in the index, PostgreSQL avoids reading the table.

**32. How do you see if an index is used?**
`EXPLAIN ANALYZE` the query; check `pg_stat_user_indexes` for usage counts.

**33. What is HOT (Heap-Only Tuple) update?**
An optimization where an update that doesn't change indexed columns avoids index updates.

**34. What is the WAL?**
Write-Ahead Log — changes are written to the log before data files, enabling crash recovery and replication.

**35. How does PostgreSQL replication work?**
Streaming replication ships WAL to replicas (physical); logical replication publishes row changes by table.

---

## C. Administration & Practical (36–50)

**36. How do you connect via psql?**
`psql -U user -d db -h host -p 5432` or a connection URI.

**37. How do you list tables / describe a table?**
`\dt` and `\d table_name`.

**38. How do you import a CSV?**
`\copy table FROM 'file.csv' CSV HEADER` (client) or `COPY` (server-side).

**39. How do you create a read-only user?**
`CREATE ROLE r LOGIN; GRANT SELECT ON ALL TABLES IN SCHEMA public TO r;` plus default privileges.

**40. What is a tablespace?**
A storage location on disk where you can place databases/tables/indexes.

**41. How do you back up a PostgreSQL database?**
`pg_dump` (logical) for a database, `pg_basebackup` for physical/cluster backups.

**42. How do you find table sizes?**
`pg_size_pretty(pg_total_relation_size('table'))`.

**43. How do you find currently running queries?**
`SELECT pid, query, state FROM pg_stat_activity WHERE state='active';`

**44. How do you cancel/kill a query?**
`pg_cancel_backend(pid)` (gentle) or `pg_terminate_backend(pid)` (force).

**45. What is connection pooling and why?**
Reuses DB connections (e.g. PgBouncer) to avoid the overhead of many short-lived connections.

**46. What are the transaction isolation levels in PostgreSQL?**
Read Committed (default), Repeatable Read, Serializable. (Read Uncommitted behaves like Read Committed.)

**47. What is `SET statement_timeout`?**
Aborts any statement running longer than the limit — useful guardrail for AI/ad-hoc queries.

**48. How do you handle schema migrations?**
Tools like Flyway, Liquibase, or framework migrations; apply versioned DDL changes in transactions.

**49. What is `EXPLAIN (ANALYZE, BUFFERS)`?**
Adds buffer/cache hit info to the plan, revealing I/O patterns.

**50. How do you secure a PostgreSQL database?**
Least-privilege roles, `pg_hba.conf` host rules, SSL/TLS, strong auth (scram-sha-256), network restrictions, and statement timeouts.

---

> Next: [Data Engineering (50)](04-data-engineering.md) · [Snowflake (50)](05-snowflake.md)
