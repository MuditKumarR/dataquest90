# 🔧 Data Engineering SQL Interview Questions — 50 Questions with Answers

> ETL/ELT, pipelines, modeling, and data quality.

---

## A. ETL / ELT (1–15)

**1. Difference between ETL and ELT?**
ETL transforms before loading (traditional); ELT loads raw then transforms inside the warehouse (modern, leverages cheap cloud compute).

**2. Why has ELT become dominant?**
Cloud warehouses (Snowflake/BigQuery) make in-warehouse transformation cheap and scalable; loading raw first is faster and more flexible.

**3. What is the medallion (bronze/silver/gold) architecture?**
Bronze = raw landing, Silver = cleaned/standardized, Gold = business-ready aggregates. Each layer is a SQL transformation.

**4. What is idempotency in pipelines? Why matter?**
Re-running a job produces the same result. Critical so retries/backfills don't duplicate or corrupt data.

**5. How do you make a load idempotent?**
Use `MERGE`/upserts keyed on a business key, or delete-then-insert for a partition, instead of blind appends.

**6. What is a watermark in incremental loads?**
A stored marker (e.g. max `updated_at`) used to fetch only rows changed since the last run.

**7. What is CDC (Change Data Capture)?**
Capturing inserts/updates/deletes from a source so only changes propagate downstream.

**8. CDC approaches?**
Timestamp-based, trigger-based, log-based (reading the DB transaction log — e.g. Debezium), and snapshot diffing.

**9. What is backfilling?**
Re-processing historical data through a new/fixed pipeline.

**10. What is a full load vs incremental load?**
Full reloads everything (simple, expensive); incremental loads only changes (efficient, needs CDC/watermark).

**11. How do you do an upsert in SQL?**
`MERGE` (PG15+/Snowflake) or PostgreSQL `INSERT ... ON CONFLICT DO UPDATE`.

**12. What is a staging area?**
A landing zone for raw extracted data before transformation/validation.

**13. What is data lineage?**
Tracking data's origin and transformations end-to-end — vital for trust and debugging.

**14. What is dbt and how does it use SQL?**
dbt organizes SQL `SELECT` statements into version-controlled, tested, dependency-managed models for the transformation (T) layer.

**15. What are dbt tests?**
Built-in assertions: `not_null`, `unique`, `relationships`, `accepted_values` — implemented as SQL that should return zero rows.

---

## B. Data Modeling (16–30)

**16. What is dimensional modeling?**
Designing fact and dimension tables (star/snowflake schemas) optimized for analytics.

**17. Fact vs dimension table?**
Facts hold measurements (numeric, many rows); dimensions hold descriptive context.

**18. What is the grain of a fact table?**
What a single row represents (e.g. one order line). Define it first.

**19. Star vs snowflake schema?**
Star = denormalized dimensions (one hop). Snowflake = normalized dimensions (sub-dimensions, more joins).

**20. What is a surrogate key? Why use one?**
A system-generated key independent of business keys — stable across source changes and enables SCD history.

**21. What is a conformed dimension?**
A dimension shared consistently across multiple fact tables (e.g. one `dim_date`).

**22. Explain SCD Type 1, 2, 3.**
Type 1 overwrites (no history); Type 2 adds a new row per change (full history); Type 3 keeps a previous-value column (limited history).

**23. What are the fact table types?**
Transaction, periodic snapshot, accumulating snapshot.

**24. What is a factless fact table?**
A fact table with no measures — records events/relationships (e.g. attendance, eligibility).

**25. What is a junk dimension?**
Combines low-cardinality flags/indicators into one dimension to reduce fact columns.

**26. What is a degenerate dimension?**
A dimension key stored in the fact with no separate dimension table (e.g. order number).

**27. What is a bridge table?**
Resolves many-to-many relationships between a fact and a dimension.

**28. Normalization vs denormalization in warehousing?**
OLTP normalizes for integrity; analytics often denormalizes (star schema, wide tables) for read speed.

**29. What is an aggregate/summary table?**
Pre-computed rollups to accelerate common dashboard queries.

**30. What is a slowly changing fact?**
Rare — facts are usually immutable; corrections are handled via reversing entries rather than updates.

---

## C. Pipelines, Quality & Orchestration (31–50)

**31. What is Apache Airflow?**
A workflow orchestrator that schedules and monitors pipelines as DAGs; tasks often run SQL.

**32. What is a DAG?**
Directed Acyclic Graph — tasks with dependencies and no cycles.

**33. Batch vs streaming?**
Batch processes data in scheduled chunks (higher latency); streaming processes continuously (low latency).

**34. When choose streaming over batch?**
Real-time needs: fraud detection, live dashboards, alerting. Batch suits daily reports/payroll.

**35. What tools handle streaming?**
Kafka, Flink, Spark Structured Streaming, Snowflake Streams/Snowpipe.

**36. What is exactly-once processing?**
Each record affects the result exactly once despite retries — achieved via idempotency + transactional sinks.

**37. What data quality checks belong in pipelines?**
Null checks, uniqueness, referential integrity, range/domain checks, freshness, row-count anomalies.

**38. Write a SQL null check.**
`SELECT COUNT(*) FROM t WHERE critical_col IS NULL;` (expect 0).

**39. Write a SQL duplicate check.**
`SELECT key, COUNT(*) FROM t GROUP BY key HAVING COUNT(*) > 1;` (expect no rows).

**40. Write a referential integrity check.**
`SELECT a.* FROM a LEFT JOIN b ON a.fk=b.id WHERE b.id IS NULL;` (expect no orphans).

**41. What is data freshness and how to monitor?**
How recent the data is; monitor `MAX(loaded_at)` vs SLA and alert if stale.

**42. What is schema drift? How handle it?**
Source schema changes breaking pipelines; handle with schema validation, evolution rules, and alerts.

**43. What is partitioning in big-data tables?**
Splitting data by a column (e.g. date) so queries scan fewer files/partitions.

**44. What is partition pruning?**
The engine skips partitions that can't match the filter, reducing scanned data.

**45. What is PySpark and how does SQL fit?**
A Python API for Spark; you can run Spark SQL on distributed datasets with the same SQL you know.

**46. What is a feature store?**
A system serving curated features (often SQL aggregations) consistently to ML training and inference.

**47. What is data observability?**
Monitoring freshness, volume, schema, distribution, and lineage to detect data issues early.

**48. How do you handle late-arriving data?**
Use event-time windows, watermarks, and reprocessing/backfill logic for records arriving after their window.

**49. What is a slowly-changing pipeline failure recovery strategy?**
Idempotent tasks + checkpoints/watermarks + ability to re-run a specific partition without side effects.

**50. How do you ensure pipeline reliability?**
Idempotency, retries with backoff, data quality gates, monitoring/alerting, lineage, and tested transformations.

---

> Next: [Snowflake (50)](05-snowflake.md)
