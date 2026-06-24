# 📦 Loading the DataVerse Inc. Sample Data

## Overview

The DataVerse Inc. database contains 12 realistic business datasets that you will use throughout all 14 missions.

**Load time:** ~30 seconds

---

## Prerequisites

- PostgreSQL running (local or Docker)
- `psql` command available
- The `dataverse` database created

---

## Step 1 — Create the Database

```bash
psql -U postgres -h localhost
```

```sql
CREATE DATABASE dataverse;
\c dataverse
```

Type `\q` to exit psql.

---

## Step 2 — Load All Datasets

From the repository root folder:

```bash
psql -U postgres -h localhost -d dataverse -f DATASETS/00-load-all.sql
```

This runs all dataset scripts in the correct order.

---

## Step 3 — Verify the Data

```bash
psql -U postgres -h localhost -d dataverse
```

```sql
-- Check all tables exist
\dt

-- Check row counts
SELECT 
    schemaname,
    tablename,
    n_live_tup as row_count
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;
```

Expected output:

```
 tablename              | row_count
------------------------+-----------
 sales_transactions     |      500
 employees              |      150
 customers              |      300
 orders                 |      400
 products               |      120
 departments            |       12
 attendance             |     1200
 performance_reviews    |      300
 recruitment            |       80
 learning               |      200
 finance_budget         |       96
 hr_analytics           |      150
```

---

## Step 4 — Test a Query

```sql
SELECT 
    e.first_name,
    e.last_name,
    d.department_name,
    e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
LIMIT 10;
```

If you see results, the data loaded correctly.

---

## Docker Specific Loading

If using Docker:

```bash
# Method 1: Copy and run
docker cp DATASETS/00-load-all.sql postgres-learning:/tmp/
docker exec -it postgres-learning psql -U postgres -d dataverse -f /tmp/00-load-all.sql

# Method 2: Pipe directly
cat DATASETS/00-load-all.sql | docker exec -i postgres-learning psql -U postgres -d dataverse
```

---

## Dataset Overview

| Dataset File | Tables Created | Rows | Business Area |
|-------------|----------------|------|---------------|
| 01-departments.sql | departments | 12 | HR |
| 02-employees.sql | employees | 150 | HR |
| 03-products.sql | products | 120 | Sales |
| 04-customers.sql | customers | 300 | Sales/Marketing |
| 05-orders.sql | orders | 400 | Sales |
| 06-sales-transactions.sql | sales_transactions | 500 | Finance |
| 07-attendance.sql | attendance | 1200 | HR |
| 08-performance-reviews.sql | performance_reviews | 300 | HR |
| 09-recruitment.sql | recruitment | 80 | HR |
| 10-learning.sql | learning_enrollments | 200 | L&D |
| 11-finance-budget.sql | finance_budget | 96 | Finance |
| 12-hr-analytics.sql | hr_analytics_summary | 150 | Analytics |

---

## Resetting the Database

If you want to start fresh:

```bash
psql -U postgres -h localhost
```

```sql
DROP DATABASE dataverse;
CREATE DATABASE dataverse;
\q
```

Then reload: 

```bash
psql -U postgres -h localhost -d dataverse -f DATASETS/00-load-all.sql
```

---

## Troubleshooting

### "database dataverse does not exist"

```bash
psql -U postgres -h localhost -c "CREATE DATABASE dataverse;"
```

### "permission denied"

```bash
psql -U postgres -h localhost -c "GRANT ALL PRIVILEGES ON DATABASE dataverse TO postgres;"
```

### "file not found"

Make sure you are running the command from the repository root folder:

```bash
ls DATASETS/00-load-all.sql  # Should exist
```

### "syntax error" during load

Ensure you are using **PostgreSQL** — not MySQL or SQLite. The SQL uses PostgreSQL-specific syntax.

---

## Next Step

You are ready to begin:

→ [Begin Mission 01](../MISSIONS/MISSION-01/README.md)
