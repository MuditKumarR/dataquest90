# 📝 SQL Basics Cheat Sheet (PostgreSQL 17)

> Print this. Pin it. Master it.

---

## SELECT — Retrieve Data

```sql
SELECT column1, column2 FROM table_name;
SELECT * FROM employees;                    -- all columns
SELECT DISTINCT department_id FROM employees; -- unique values
SELECT first_name AS name FROM employees;     -- alias
```

## Filtering — WHERE

```sql
SELECT * FROM employees WHERE salary > 50000;
WHERE status = 'Active' AND department_id = 4;
WHERE department_id IN (1, 2, 3);
WHERE salary BETWEEN 40000 AND 80000;
WHERE first_name LIKE 'J%';        -- starts with J
WHERE email ILIKE '%@dataverse%';  -- case-insensitive
WHERE manager_id IS NULL;          -- NULL check
WHERE NOT status = 'Terminated';
```

## Sorting & Limiting

```sql
SELECT * FROM employees ORDER BY salary DESC;
SELECT * FROM employees ORDER BY department_id, salary DESC;
SELECT * FROM employees ORDER BY salary DESC LIMIT 10;
SELECT * FROM employees ORDER BY salary DESC OFFSET 10 LIMIT 10; -- pagination
```

## Aggregations

```sql
SELECT COUNT(*) FROM employees;
SELECT SUM(salary), AVG(salary), MIN(salary), MAX(salary) FROM employees;
SELECT department_id, COUNT(*) 
FROM employees GROUP BY department_id;
SELECT department_id, AVG(salary)
FROM employees GROUP BY department_id
HAVING AVG(salary) > 60000;        -- filter groups
```

## Filtered Aggregates (PostgreSQL)

```sql
SELECT 
    COUNT(*) FILTER (WHERE status = 'Active') AS active,
    COUNT(*) FILTER (WHERE status = 'Terminated') AS terminated
FROM employees;
```

## String Functions

```sql
first_name || ' ' || last_name      -- concatenation
UPPER(name), LOWER(name), INITCAP(name)
LENGTH(name), TRIM(name)
SUBSTRING(name FROM 1 FOR 3)
REPLACE(phone, '-', '')
LEFT(name, 3), RIGHT(name, 3)
```

## Date Functions

```sql
CURRENT_DATE, NOW(), CURRENT_TIMESTAMP
EXTRACT(YEAR FROM hire_date)
DATE_TRUNC('month', hire_date)
AGE(CURRENT_DATE, hire_date)
hire_date + INTERVAL '30 days'
TO_CHAR(hire_date, 'YYYY-MM-DD')
```

## CASE — Conditional Logic

```sql
SELECT first_name,
    CASE 
        WHEN salary > 100000 THEN 'High'
        WHEN salary > 60000  THEN 'Medium'
        ELSE 'Standard'
    END AS salary_band
FROM employees;
```

## NULL Handling

```sql
COALESCE(phone, 'N/A')          -- first non-null
NULLIF(a, b)                    -- NULL if a=b (avoid div/0)
salary IS NULL / IS NOT NULL
```

## Math

```sql
ROUND(salary, 2), CEIL(x), FLOOR(x), ABS(x), MOD(a, b)
POWER(2, 3), SQRT(16)
```

---

## 🧠 Execution Order (how SQL actually runs)

```
FROM → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT
```

> You write `SELECT` first, but the database runs `FROM` first!

---

## ⚡ Quick Reference

| Want to... | Use |
|------------|-----|
| Pick columns | `SELECT` |
| Filter rows | `WHERE` |
| Group rows | `GROUP BY` |
| Filter groups | `HAVING` |
| Sort | `ORDER BY` |
| Limit rows | `LIMIT` |
| Unique values | `DISTINCT` |
| Rename | `AS` |
| Combine text | `\|\|` |
