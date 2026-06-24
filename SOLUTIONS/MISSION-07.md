# ✅ Mission 7 — Solutions

Worked solutions for [Mission 7](../MISSIONS/MISSION-07/README.md). Try first!

---

### 1. Rank employees by salary

```sql
SELECT first_name, last_name, salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;
```

### 2. Number employees by salary within each location

```sql
SELECT first_name, last_name, location, salary,
       ROW_NUMBER() OVER (PARTITION BY location ORDER BY salary DESC) AS rn
FROM employees;
```

### 3. Top 2 highest-paid per department

```sql
WITH ranked AS (
    SELECT first_name, last_name, department_id, salary,
           ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
    FROM employees
)
SELECT * FROM ranked WHERE rn <= 2;
```

### 4. Five salary bands with NTILE

```sql
SELECT first_name, last_name, salary,
       NTILE(5) OVER (ORDER BY salary DESC) AS salary_band
FROM employees;
```

### 5. Monthly revenue with next month (LEAD)

```sql
SELECT fiscal_year, fiscal_month,
       SUM(revenue) AS monthly_revenue,
       LEAD(SUM(revenue)) OVER (ORDER BY fiscal_year, fiscal_month) AS next_month
FROM sales_transactions
GROUP BY fiscal_year, fiscal_month
ORDER BY fiscal_year, fiscal_month;
```

### 6. Salary vs department average

```sql
SELECT first_name, last_name, department_id, salary,
       ROUND(AVG(salary) OVER (PARTITION BY department_id), 2) AS dept_avg
FROM employees;
```

### 7. Running total of budget for department 4

```sql
SELECT fiscal_year, fiscal_quarter, budgeted_amount,
       SUM(budgeted_amount) OVER (ORDER BY fiscal_year, fiscal_quarter) AS running_total
FROM finance_budget
WHERE department_id = 4
ORDER BY fiscal_year, fiscal_quarter;
```

### 8. Customer rank within industry

```sql
SELECT company_name, industry, lifetime_value,
       DENSE_RANK() OVER (PARTITION BY industry ORDER BY lifetime_value DESC) AS industry_rank
FROM customers;
```

---

## 🔥 Challenge — Sales leaderboard with momentum

```sql
WITH rep_year AS (
    SELECT s.sales_rep_id, s.fiscal_year, SUM(s.revenue) AS revenue
    FROM sales_transactions s
    GROUP BY s.sales_rep_id, s.fiscal_year
),
with_growth AS (
    SELECT sales_rep_id, fiscal_year, revenue,
           LAG(revenue) OVER (PARTITION BY sales_rep_id ORDER BY fiscal_year) AS prev_year
    FROM rep_year
)
SELECT e.first_name || ' ' || e.last_name AS rep,
       wg.fiscal_year, wg.revenue, wg.prev_year,
       ROUND(100.0 * (wg.revenue - wg.prev_year) / NULLIF(wg.prev_year, 0), 1) AS yoy_growth_pct,
       RANK() OVER (PARTITION BY wg.fiscal_year ORDER BY wg.revenue DESC) AS year_rank
FROM with_growth wg
JOIN employees e ON wg.sales_rep_id = e.employee_id
ORDER BY wg.fiscal_year, year_rank;
```

→ Next: [Mission 8 Solutions](MISSION-08.md)
