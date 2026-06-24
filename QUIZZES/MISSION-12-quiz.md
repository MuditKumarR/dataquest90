# 🧩 Mission 12 Quiz — Data Engineering Pipelines

Answers at the bottom.

---

**1.** ETL stands for:
- A) Extract, Transform, Load
- B) Export, Transfer, Link
- C) Evaluate, Test, Launch
- D) Extract, Test, Load

**2.** The key difference in ELT is:
- A) No loading
- B) Transform happens *after* load, inside the warehouse
- C) No extraction
- D) Transform happens first

**3.** In the medallion architecture, raw data lands in the:
- A) Gold layer
- B) Bronze layer
- C) Silver layer
- D) Platinum layer

**4.** The Silver layer typically contains:
- A) Raw untouched data
- B) Cleaned and conformed data
- C) Final business aggregates
- D) Backups

**5.** CDC (Change Data Capture) tracks:
- A) Schema changes only
- B) Inserts/updates/deletes in source data
- C) User logins
- D) Index rebuilds

**6.** An upsert in PostgreSQL uses:
- A) `MERGE ONLY`
- B) `INSERT ... ON CONFLICT ... DO UPDATE`
- C) `UPDATE OR INSERT`
- D) `REPLACE INTO`

**7.** Which tool commonly orchestrates pipelines (DAGs)?
- A) Tableau
- B) Apache Airflow
- C) Excel
- D) Power BI

**8.** A data quality check might verify:
- A) Font size
- B) No NULLs in required columns, no duplicates, valid ranges
- C) Color themes
- D) File names

---

## ✅ Answers
1-A · 2-B · 3-B · 4-B · 5-B · 6-B · 7-B · 8-B

**Score 6+?** Advance to [Mission 13](../MISSIONS/MISSION-13/README.md). See [ETL](../DIAGRAMS/etl-flow.md) & [ELT](../DIAGRAMS/elt-flow.md) diagrams.
