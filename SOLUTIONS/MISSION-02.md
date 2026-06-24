# ✅ Mission 2 — Solutions

Worked solutions for [Mission 2](../MISSIONS/MISSION-02/README.md). Try first!

---

### 1. Employees on leave

```sql
SELECT first_name, last_name, status
FROM employees
WHERE status = 'On Leave';
```

### 2. Full-Time employees earning $100K–$150K

```sql
SELECT first_name, last_name, salary
FROM employees
WHERE employment_type = 'Full-Time'
  AND salary BETWEEN 100000 AND 150000;
```

### 3. Names starting with A or B

```sql
SELECT first_name, last_name
FROM employees
WHERE first_name LIKE 'A%' OR first_name LIKE 'B%';
```

### 4. Employees in Chicago, Dallas, or Houston

```sql
SELECT first_name, last_name, location
FROM employees
WHERE location IN ('Chicago', 'Dallas', 'Houston');
```

### 5. Emails containing 'son'

```sql
SELECT first_name, last_name, email
FROM employees
WHERE email LIKE '%son%';
```

### 6. Active employees with no termination date

```sql
SELECT first_name, last_name, status, termination_date
FROM employees
WHERE termination_date IS NULL
  AND status = 'Active';
```

### 7. Contract or Intern earning under $70K

```sql
SELECT first_name, last_name, employment_type, salary
FROM employees
WHERE employment_type IN ('Contract', 'Intern')
  AND salary < 70000;
```

### 8. Employees hired in 2021

```sql
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '2021-01-01' AND '2021-12-31';
```

---

## 🔥 Challenge — Flight risk list

```sql
SELECT first_name, last_name, hire_date, salary
FROM employees
WHERE status = 'Active'
  AND employment_type = 'Full-Time'
  AND hire_date >= '2022-01-01'
  AND salary < 90000
ORDER BY salary ASC;
```

→ Next: [Mission 3 Solutions](MISSION-03.md)
