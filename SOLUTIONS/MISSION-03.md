# ✅ Mission 3 — Solutions

Worked solutions for [Mission 3](../MISSIONS/MISSION-03/README.md). Try first!

---

### 1. Count employees per employment type

```sql
SELECT employment_type, COUNT(*) AS headcount
FROM employees
GROUP BY employment_type
ORDER BY headcount DESC;
```

### 2. Total payroll per location

```sql
SELECT location, SUM(salary) AS total_payroll
FROM employees
GROUP BY location
ORDER BY total_payroll DESC;
```

### 3. Average salary per status

```sql
SELECT status, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY status;
```

### 4. Statuses with more than 2 people

```sql
SELECT status, COUNT(*) AS headcount
FROM employees
GROUP BY status
HAVING COUNT(*) > 2;
```

### 5. Company-wide MIN, MAX, AVG salary

```sql
SELECT MIN(salary) AS min_salary,
       MAX(salary) AS max_salary,
       ROUND(AVG(salary), 2) AS avg_salary
FROM employees;
```

### 6. Headcount + payroll per location, sorted

```sql
SELECT location, COUNT(*) AS headcount, SUM(salary) AS total_payroll
FROM employees
GROUP BY location
ORDER BY total_payroll DESC;
```

### 7. Departments with fewer than 3 employees

```sql
SELECT department_id, COUNT(*) AS headcount
FROM employees
GROUP BY department_id
HAVING COUNT(*) < 3;
```

### 8. Average salary per location, Active only

```sql
SELECT location, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
WHERE status = 'Active'
GROUP BY location
ORDER BY avg_salary DESC;
```

---

## 🔥 Challenge — Department cost efficiency

```sql
SELECT department_id,
       COUNT(*) AS headcount,
       SUM(salary) AS total_payroll,
       ROUND(AVG(salary), 2) AS avg_salary,
       MAX(salary) - MIN(salary) AS salary_range
FROM employees
GROUP BY department_id
HAVING COUNT(*) >= 4
ORDER BY total_payroll DESC;
```

→ Next: [Mission 4 Solutions](MISSION-04.md)
