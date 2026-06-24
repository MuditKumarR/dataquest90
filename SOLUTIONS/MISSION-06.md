# ✅ Mission 6 — Solutions

Worked solutions for [Mission 6](../MISSIONS/MISSION-06/README.md). Try first!

---

### 1. CTE: payroll per department, joined to names

```sql
WITH dept_payroll AS (
    SELECT department_id, SUM(salary) AS total_payroll
    FROM employees
    GROUP BY department_id
)
SELECT d.department_name, dp.total_payroll
FROM dept_payroll dp
JOIN departments d ON dp.department_id = d.department_id
ORDER BY dp.total_payroll DESC;
```

### 2. Two-step CTE: departments above company average

```sql
WITH dept_avg AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT department_id, ROUND(avg_salary, 2) AS avg_salary
FROM dept_avg
WHERE avg_salary > (SELECT AVG(salary) FROM employees)
ORDER BY avg_salary DESC;
```

### 3. Recursive CTE: everyone reporting to the CTO (id 3)

```sql
WITH RECURSIVE reports AS (
    SELECT employee_id, first_name, last_name, manager_id
    FROM employees
    WHERE employee_id = 3
    UNION ALL
    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id
    FROM employees e
    JOIN reports r ON e.manager_id = r.employee_id
)
SELECT * FROM reports WHERE employee_id <> 3;
```

### 4. View of active employees with department names

```sql
CREATE OR REPLACE VIEW v_active_employees AS
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.status = 'Active';
```

### 5. Materialized view of department headcount

```sql
CREATE MATERIALIZED VIEW mv_dept_headcount AS
SELECT department_id, COUNT(*) AS headcount, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id;

REFRESH MATERIALIZED VIEW mv_dept_headcount;
```

### 6. Top 5 customers + % of total revenue

```sql
WITH cust_rev AS (
    SELECT c.company_name, SUM(oi.line_total) AS revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.company_name
)
SELECT company_name, revenue,
       ROUND(100.0 * revenue / SUM(revenue) OVER (), 2) AS pct_of_total
FROM cust_rev
ORDER BY revenue DESC
LIMIT 5;
```

### 7. Recursive CTE generating 1–10

```sql
WITH RECURSIVE nums AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM nums WHERE n < 10
)
SELECT n FROM nums;
```

---

## 🔥 Challenge — Management depth report

```sql
WITH RECURSIVE org AS (
    SELECT employee_id, first_name, last_name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id, o.level + 1
    FROM employees e
    JOIN org o ON e.manager_id = o.employee_id
)
SELECT o.first_name || ' ' || o.last_name AS employee,
       m.first_name || ' ' || m.last_name AS manager,
       o.level
FROM org o
LEFT JOIN employees m ON o.manager_id = m.employee_id
ORDER BY o.level, employee;
```

→ Next: [Mission 7 Solutions](MISSION-07.md)
