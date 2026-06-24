# ✅ Mission 1 — Solutions

Worked solutions for [Mission 1](../MISSIONS/MISSION-01/README.md) exercises. Try them yourself first!

---

### 1. First 15 employees — name and email

```sql
SELECT first_name, last_name, email
FROM employees
LIMIT 15;
```

### 2. All distinct employment types

```sql
SELECT DISTINCT employment_type
FROM employees
ORDER BY employment_type;
```

### 3. 10 lowest-paid employees

```sql
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary ASC
LIMIT 10;
```

### 4. Distinct location + employment_type combinations

```sql
SELECT DISTINCT location, employment_type
FROM employees
ORDER BY location, employment_type;
```

### 5. Job title and hire date, oldest first

```sql
SELECT first_name, last_name, job_title, hire_date
FROM employees
ORDER BY hire_date ASC;
```

### 6. Distinct department_id values

```sql
SELECT DISTINCT department_id
FROM employees
ORDER BY department_id;
-- Count the rows returned to see how many departments have staff.
```

### 7. 3 most recently hired employees

```sql
SELECT first_name, last_name, hire_date
FROM employees
ORDER BY hire_date DESC
LIMIT 3;
```

---

## 🔥 Challenge — Top 10 by full name + salary

```sql
SELECT first_name || ' ' || last_name AS full_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 10;
```

→ Next: [Mission 2 Solutions](MISSION-02.md)
