# 🐘 PostgreSQL Commands Cheat Sheet

> psql meta-commands, admin, and PostgreSQL-specific features.

---

## psql Meta-Commands

```
\l              list databases
\c dbname       connect to database
\dt             list tables
\d table_name   describe table (columns, indexes, FKs)
\dn             list schemas
\df             list functions
\dv             list views
\di             list indexes
\du             list roles/users
\x              toggle expanded display (great for wide rows)
\timing         toggle query timing
\i file.sql     run a SQL file
\copy           import/export CSV (client-side)
\q              quit
\?              psql help
\h SELECT       SQL syntax help for a command
```

## Connecting

```bash
psql -U postgres -d dataverse -h localhost -p 5432
psql "postgresql://postgres:postgres@localhost:5432/dataverse"
```

## Database & Table Management

```sql
CREATE DATABASE dataverse;
DROP DATABASE dataverse;

CREATE TABLE t (id SERIAL PRIMARY KEY, name TEXT NOT NULL);
ALTER TABLE t ADD COLUMN email TEXT;
ALTER TABLE t DROP COLUMN email;
ALTER TABLE t RENAME COLUMN name TO full_name;
ALTER TABLE t ALTER COLUMN name SET NOT NULL;
DROP TABLE t;
TRUNCATE TABLE t;             -- fast delete all rows
```

## Data Types (PostgreSQL)

```sql
SERIAL / BIGSERIAL          -- auto-increment
INTEGER, BIGINT, SMALLINT
NUMERIC(p,s), DECIMAL       -- exact decimals (money!)
REAL, DOUBLE PRECISION      -- floating point
VARCHAR(n), TEXT            -- strings (TEXT has no penalty)
BOOLEAN
DATE, TIME, TIMESTAMP, TIMESTAMPTZ, INTERVAL
JSON, JSONB                 -- semi-structured (use JSONB)
UUID
ARRAY (e.g. INTEGER[])
```

## Constraints

```sql
PRIMARY KEY, FOREIGN KEY ... REFERENCES other(id)
UNIQUE, NOT NULL, CHECK (salary > 0)
DEFAULT NOW()
GENERATED ALWAYS AS (qty * price) STORED   -- computed column
```

## Indexes

```sql
CREATE INDEX idx_emp_dept ON employees(department_id);
CREATE UNIQUE INDEX ON employees(email);
CREATE INDEX ON employees(lower(email));    -- functional
CREATE INDEX ON orders(customer_id, order_date);  -- composite
DROP INDEX idx_emp_dept;
```

## JSONB

```sql
SELECT data->>'name' FROM t;          -- text
SELECT data->'address'->>'city' FROM t;
SELECT * FROM t WHERE data @> '{"active": true}';   -- contains
CREATE INDEX ON t USING gin(data);    -- index JSONB
```

## Arrays

```sql
SELECT ARRAY[1,2,3];
SELECT * FROM t WHERE 5 = ANY(tags);
SELECT unnest(tags) FROM t;
```

## generate_series — Make Rows

```sql
SELECT generate_series(1, 10);
SELECT generate_series('2024-01-01'::date, '2024-12-31', '1 day');
```

## Roles & Permissions

```sql
CREATE ROLE analyst LOGIN PASSWORD 'pw';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst;
GRANT ALL PRIVILEGES ON DATABASE dataverse TO admin;
REVOKE INSERT ON employees FROM analyst;
ALTER ROLE analyst SET statement_timeout = '10s';
```

## Performance & Maintenance

```sql
EXPLAIN SELECT ...;             -- query plan
EXPLAIN ANALYZE SELECT ...;     -- plan + actual timing
VACUUM;                         -- reclaim space
VACUUM ANALYZE;                 -- + update statistics
ANALYZE employees;              -- update planner stats
REINDEX TABLE employees;
```

## Transactions

```sql
BEGIN;
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;     -- or ROLLBACK;

SAVEPOINT sp1;
ROLLBACK TO sp1;
```

## Useful System Queries

```sql
-- Table sizes
SELECT relname, pg_size_pretty(pg_total_relation_size(relid))
FROM pg_catalog.pg_statio_user_tables ORDER BY pg_total_relation_size(relid) DESC;

-- Active queries
SELECT pid, query, state FROM pg_stat_activity WHERE state = 'active';

-- Current database/version
SELECT current_database(), version();
```

---

## 🧠 PostgreSQL-Specific Power Features

| Feature | Use |
|---------|-----|
| `FILTER (WHERE ...)` | conditional aggregates |
| `DISTINCT ON (col)` | first row per group |
| `GENERATED ... STORED` | computed columns |
| `ILIKE` | case-insensitive match |
| `||` | string concat |
| `RETURNING` | get inserted/updated rows |
| `ON CONFLICT` | upsert |
| `JSONB` | document storage |
| `generate_series` | row generation |
| `LATERAL` joins | per-row subqueries |
