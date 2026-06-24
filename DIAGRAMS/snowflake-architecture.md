# 📊 Snowflake Architecture

Snowflake's defining innovation: **separation of storage and compute**, coordinated by a cloud services layer.

---

## The Three Layers

```mermaid
graph TB
    subgraph "Cloud Services Layer"
    CS[Query Optimizer · Metadata · Security<br/>Transactions · Result Cache]
    end
    subgraph "Compute Layer (Virtual Warehouses)"
    VW1[ETL Warehouse<br/>X-Large]
    VW2[BI Warehouse<br/>Medium]
    VW3[Data Science<br/>Large]
    end
    subgraph "Storage Layer"
    ST[(Centralized Storage<br/>Compressed Micro-partitions)]
    end
    CS --> VW1 & VW2 & VW3
    VW1 & VW2 & VW3 --> ST
```

- **Cloud Services** — the brain: optimizes queries, manages metadata, security, transactions, and the result cache.
- **Compute** — independent virtual warehouses; scale each per workload, pay only while running.
- **Storage** — one copy of data; all warehouses read it without contention.

---

## Why Separation Matters

```mermaid
graph LR
    ST[(Shared Storage)] --> ETL[ETL team<br/>heavy load]
    ST --> BI[BI team<br/>dashboards]
    ST --> DS[Data Science<br/>experiments]
    note[No resource competition:<br/>each team scales independently]
```

The ETL team can run a huge job on an X-Large warehouse while the BI team queries the same data on a Medium — no fighting for resources.

---

## Pipeline Features

```mermaid
graph LR
    RAW[(Raw table)] --> STREAM[Stream<br/>captures changes/CDC]
    STREAM --> TASK[Task<br/>scheduled SQL]
    TASK --> TARGET[(Target table)]
    DT[Dynamic Table<br/>auto-refresh] -.declarative alt.-> TARGET
```

---

## Cost Control & Operations

| Feature | Benefit |
|---------|---------|
| Auto-suspend | Stop billing when idle |
| Auto-resume | Wake on demand |
| Result cache | Repeat queries are free (24h) |
| Time Travel | Recover past data |
| Zero-Copy Clone | Instant free environments |
| Micro-partitions | Automatic — no index tuning |

→ Related: [Mission 11](../MISSIONS/MISSION-11/README.md) · [Project 06](../PROJECTS/PROJECT-06/README.md) · [Snowflake Cheat Sheet](../CHEATSHEETS/08-snowflake-sql-mapping.md)
