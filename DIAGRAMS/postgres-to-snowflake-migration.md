# 📊 PostgreSQL to Snowflake Migration

The path from a self-managed PostgreSQL warehouse to a Snowflake cloud warehouse.

---

## Migration Flow

```mermaid
graph LR
    subgraph "Source: PostgreSQL"
    PG[(dim_* + fact_*)]
    end
    subgraph "Export"
    DUMP[pg_dump / COPY<br/>to CSV/Parquet]
    end
    subgraph "Stage"
    STAGE[Snowflake Stage<br/>internal or S3]
    end
    subgraph "Target: Snowflake"
    SF[(Snowflake DW)]
    PIPE[Streams + Tasks<br/>incremental]
    end
    PG --> DUMP --> STAGE
    STAGE -->|COPY INTO| SF
    SF --> PIPE
```

---

## Migration Steps

```mermaid
graph TD
    A[1. Translate DDL<br/>SERIAL→AUTOINCREMENT, drop indexes] --> B[2. Provision warehouses<br/>+ auto-suspend]
    B --> C[3. Export data<br/>CSV/Parquet]
    C --> D[4. Upload to stage<br/>PUT]
    D --> E[5. COPY INTO tables]
    E --> F[6. Validate row counts]
    F --> G[7. Build incremental pipeline<br/>Streams + Tasks]
    G --> H[8. Cutover + monitor]
```

---

## What Changes

| PostgreSQL | Snowflake |
|------------|-----------|
| `SERIAL` | `AUTOINCREMENT` |
| `NUMERIC(p,s)` | `NUMBER(p,s)` |
| `TEXT` | `VARCHAR` |
| `JSONB` | `VARIANT` |
| `CREATE INDEX` | *(automatic — drop them)* |
| `PARTITION BY` | `CLUSTER BY` (optional) |
| `VACUUM`/`ANALYZE` | *(automatic — remove)* |
| `REFRESH MATERIALIZED VIEW` | Dynamic Table (auto) |
| pg_dump / COPY | Stage + `COPY INTO` |

---

## What Stays the Same

```
SELECT, JOIN, GROUP BY, HAVING, ORDER BY, window functions,
CTEs, CASE, COALESCE, UNION/INTERSECT/EXCEPT, ILIKE — all unchanged.
```

90% of your queries migrate as-is. Effort concentrates on DDL, loading, and pipelines.

---

## Rollback Strategy

- Keep PostgreSQL running in parallel during validation.
- Compare row counts and key aggregates between systems.
- Use Snowflake **Zero-Copy Clone** for safe test runs.
- Cut over only after parity is confirmed.

→ Related: [Mission 11](../MISSIONS/MISSION-11/README.md) · [Project 06](../PROJECTS/PROJECT-06/README.md) · [Snowflake Cheat Sheet](../CHEATSHEETS/08-snowflake-sql-mapping.md)
