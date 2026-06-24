# ❄️ Snowflake Interview Questions — 50 Questions with Answers

> Cloud data warehouse architecture and features.

---

## A. Architecture (1–15)

**1. What is Snowflake?**
A cloud-native data warehouse (SaaS) that separates storage and compute, runs on AWS/Azure/GCP, and uses ANSI SQL.

**2. Describe Snowflake's three-layer architecture.**
Cloud Services (optimization, metadata, security), Compute (virtual warehouses), and Storage (centralized, compressed micro-partitions).

**3. Why is storage/compute separation important?**
Multiple compute clusters can query the same data independently — scale compute without moving data and avoid resource contention.

**4. What is a virtual warehouse?**
An independent compute cluster (T-shirt sized) that executes queries. You can have many, sized per workload.

**5. What is auto-suspend / auto-resume?**
Warehouses pause when idle (stop billing) and resume on demand — core cost control.

**6. How is Snowflake billed?**
Compute by credits per second of warehouse runtime; storage by compressed TB per month; plus serverless features.

**7. What are micro-partitions?**
Automatic ~50–500MB (uncompressed) immutable storage units with min/max metadata enabling pruning. No manual partitioning.

**8. What is partition pruning?**
Snowflake uses micro-partition metadata to skip partitions that can't match a query's filters.

**9. What is a clustering key?**
An optional key to co-locate related data in micro-partitions for very large tables, improving pruning.

**10. Do you create indexes in Snowflake?**
No — there are no traditional indexes; micro-partitioning + pruning replace them.

**11. What is a multi-cluster warehouse?**
A warehouse that auto-scales out to multiple clusters to handle concurrency spikes.

**12. Scaling up vs scaling out?**
Scale up = bigger warehouse (faster single queries); scale out = more clusters (more concurrent users).

**13. What cloud providers does Snowflake run on?**
AWS, Azure, and Google Cloud.

**14. What is the metadata/cloud services layer responsible for?**
Authentication, query parsing/optimization, transaction management, and metadata — including result caching.

**15. What is result caching?**
Snowflake caches query results for 24 hours; identical queries return instantly without compute.

---

## B. Key Features (16–35)

**16. What is Time Travel?**
Query or restore data as it existed in the past (default 1 day, up to 90 on Enterprise).

**17. Give a Time Travel use case.**
Recover accidentally deleted rows: `INSERT INTO t SELECT * FROM t BEFORE (STATEMENT => '<id>')`.

**18. What is `UNDROP`?**
Restores a dropped table/schema/database within the retention window.

**19. What is Zero-Copy Cloning?**
Instantly clone tables/schemas/databases without duplicating storage; clones diverge only as they change.

**20. Use case for cloning?**
Spin up full dev/test environments from production in seconds at no extra storage cost.

**21. What is a Stream?**
An object tracking table changes (CDC) — exposes changed rows with `METADATA$ACTION`.

**22. What is a Task?**
Scheduled SQL execution; can trigger on a schedule or when a stream has data, and chain into DAGs.

**23. What are Dynamic Tables?**
Declarative tables that auto-refresh from a query within a `TARGET_LAG` — replace manual Stream+Task pipelines.

**24. What is Snowpipe?**
Continuous, serverless data ingestion that auto-loads files as they arrive in a stage.

**25. What is a stage?**
A location (internal or external like S3) for staging files before `COPY INTO`.

**26. How do you bulk load data?**
`COPY INTO table FROM @stage FILE_FORMAT=(...)`.

**27. What is the VARIANT type?**
A semi-structured type storing JSON/Avro/Parquet; query with `col:path::type` and `FLATTEN`.

**28. What is `FLATTEN`?**
A table function that expands arrays/objects in VARIANT into rows.

**29. What is Secure Data Sharing?**
Share live data with other Snowflake accounts without copying — consumers query your data directly.

**30. What is the Marketplace?**
A catalog to discover and access third-party datasets/services via data sharing.

**31. What is a Materialized View in Snowflake?**
A precomputed view that Snowflake auto-maintains as base data changes (with limitations).

**32. What is Search Optimization Service?**
An add-on that speeds up selective point-lookup queries on large tables.

**33. What is a resource monitor?**
A control to track and cap credit usage, suspending warehouses at thresholds.

**34. What are roles in Snowflake?**
RBAC entities; privileges are granted to roles, roles to users. System roles include ACCOUNTADMIN, SYSADMIN, SECURITYADMIN.

**35. What is the difference between transient and permanent tables?**
Transient tables have no fail-safe and limited Time Travel — cheaper for non-critical data.

---

## C. SQL & Migration (36–50)

**36. Does Snowflake use standard SQL?**
Yes — ANSI SQL. Most PostgreSQL queries work nearly unchanged.

**37. PostgreSQL `SERIAL` equivalent?**
`AUTOINCREMENT` / `IDENTITY`.

**38. PostgreSQL `TEXT` equivalent?**
`VARCHAR` / `STRING` (no length penalty).

**39. PostgreSQL `JSONB` equivalent?**
`VARIANT`.

**40. How do you replace `CREATE INDEX` from PostgreSQL?**
You don't — rely on automatic micro-partitions; optionally add a `CLUSTER BY` key.

**41. PostgreSQL `generate_series` equivalent?**
`TABLE(GENERATOR(ROWCOUNT => n))` with `SEQ4()`.

**42. PostgreSQL `STRING_AGG` equivalent?**
`LISTAGG(col, ',')`.

**43. How do you migrate data from PostgreSQL?**
Export to CSV/Parquet, upload to a stage (`PUT`), then `COPY INTO`.

**44. How do you handle incremental loads in Snowflake?**
Streams + Tasks, or Dynamic Tables, or `MERGE` on a watermark.

**45. How do you implement SCD2 in Snowflake?**
`MERGE` to expire current rows and insert new versions, often driven by a Stream.

**46. What window functions does Snowflake support?**
The full standard set — identical to PostgreSQL (ROW_NUMBER, RANK, LAG/LEAD, etc.).

**47. What maintenance does Snowflake require?**
Effectively none — no VACUUM/ANALYZE/index maintenance; it's fully managed.

**48. How do you control cost in Snowflake?**
Right-size warehouses, aggressive auto-suspend, resource monitors, avoid unnecessary scans, leverage caching.

**49. What is a warehouse size's effect?**
Each size up roughly doubles compute (and credits/hour) and query speed for large jobs.

**50. When would you NOT use Snowflake?**
High-frequency OLTP transactional workloads (it's analytical/OLAP), or tiny workloads where a small Postgres suffices and is cheaper.

---

> 🎓 You've covered all 300 interview questions across SQL, Advanced SQL, PostgreSQL, Data Engineering, and Snowflake. Drill them until they're second nature.
