# ✅ Mission 13 — Solutions

Worked solutions for [Mission 13](../MISSIONS/MISSION-13/README.md). Try first!

---

### 1. Headcount by location (active vs inactive)

```sql
SELECT location,
       COUNT(*) FILTER (WHERE status = 'Active')   AS active,
       COUNT(*) FILTER (WHERE status <> 'Active')  AS inactive,
       COUNT(*) AS total
FROM employees
GROUP BY location
ORDER BY total DESC;
```

### 2. Attrition rate by tenure band

```sql
WITH banded AS (
    SELECT employee_id, status,
           CASE
               WHEN EXTRACT(YEAR FROM AGE(COALESCE(termination_date, CURRENT_DATE), hire_date)) < 1 THEN '0-1yr'
               WHEN EXTRACT(YEAR FROM AGE(COALESCE(termination_date, CURRENT_DATE), hire_date)) < 3 THEN '1-3yr'
               WHEN EXTRACT(YEAR FROM AGE(COALESCE(termination_date, CURRENT_DATE), hire_date)) < 5 THEN '3-5yr'
               ELSE '5+yr'
           END AS tenure_band
    FROM employees
)
SELECT tenure_band,
       COUNT(*) AS total,
       COUNT(*) FILTER (WHERE status = 'Terminated') AS left_count,
       ROUND(100.0 * COUNT(*) FILTER (WHERE status = 'Terminated') / COUNT(*), 1) AS attrition_pct
FROM banded
GROUP BY tenure_band
ORDER BY tenure_band;
```

### 3. Quarterly revenue with QoQ growth (LAG)

```sql
WITH q AS (
    SELECT fiscal_year, fiscal_quarter, SUM(revenue) AS revenue
    FROM sales_transactions
    GROUP BY fiscal_year, fiscal_quarter
)
SELECT fiscal_year, fiscal_quarter, revenue,
       ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY fiscal_year, fiscal_quarter))
             / NULLIF(LAG(revenue) OVER (ORDER BY fiscal_year, fiscal_quarter), 0), 1) AS qoq_growth_pct
FROM q
ORDER BY fiscal_year, fiscal_quarter;
```

### 4. Top 10 customers by CLV with order counts

```sql
SELECT c.company_name, c.lifetime_value, COUNT(o.order_id) AS orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.company_name, c.lifetime_value
ORDER BY c.lifetime_value DESC
LIMIT 10;
```

### 5. CLV quartiles with average revenue

```sql
WITH q AS (
    SELECT company_name, lifetime_value,
           NTILE(4) OVER (ORDER BY lifetime_value DESC) AS quartile
    FROM customers
)
SELECT quartile, COUNT(*) AS customers, ROUND(AVG(lifetime_value), 2) AS avg_clv
FROM q
GROUP BY quartile
ORDER BY quartile;
```

### 6. Recruitment funnel by department

```sql
SELECT d.department_name,
       COUNT(*) FILTER (WHERE r.stage = 'Applied')             AS applied,
       COUNT(*) FILTER (WHERE r.stage = 'Phone Interview')     AS phone,
       COUNT(*) FILTER (WHERE r.stage = 'Technical Interview') AS technical,
       COUNT(*) FILTER (WHERE r.stage = 'Offer')               AS offers,
       COUNT(*) FILTER (WHERE r.stage = 'Hired')               AS hired
FROM recruitment r
JOIN departments d ON r.department_id = d.department_id
GROUP BY d.department_name
ORDER BY hired DESC;
```

### 7. Course completion rate and average score by category

```sql
SELECT co.category,
       COUNT(*) AS enrollments,
       COUNT(*) FILTER (WHERE le.status = 'Completed') AS completed,
       ROUND(100.0 * COUNT(*) FILTER (WHERE le.status = 'Completed') / COUNT(*), 1) AS completion_pct,
       ROUND(AVG(le.final_score), 1) AS avg_score
FROM learning_enrollments le
JOIN courses co ON le.course_id = co.course_id
GROUP BY co.category
ORDER BY completion_pct DESC;
```

### 8. Single-query executive dashboard

```sql
SELECT
    (SELECT COUNT(*) FROM employees WHERE status = 'Active')              AS active_employees,
    (SELECT COUNT(*) FROM customers WHERE customer_status = 'Active')     AS active_customers,
    (SELECT SUM(revenue) FROM sales_transactions)                        AS total_revenue,
    (SELECT SUM(gross_profit) FROM sales_transactions)                   AS total_gross_profit,
    (SELECT COUNT(*) FROM orders WHERE order_status = 'Pending')          AS pending_orders,
    (SELECT ROUND(AVG(lifetime_value), 0) FROM customers)                AS avg_clv;
```

---

## 🔥 Challenge — Executive scorecard views

```sql
CREATE OR REPLACE VIEW vw_headcount AS
SELECT location, COUNT(*) FILTER (WHERE status='Active') AS active_headcount
FROM employees GROUP BY location;

CREATE OR REPLACE VIEW vw_revenue AS
SELECT fiscal_year, fiscal_quarter, SUM(revenue) AS revenue
FROM sales_transactions GROUP BY fiscal_year, fiscal_quarter;

CREATE OR REPLACE VIEW vw_retention AS
SELECT customer_status, COUNT(*) AS customers, ROUND(AVG(lifetime_value),0) AS avg_clv
FROM customers GROUP BY customer_status;

CREATE OR REPLACE VIEW vw_funnel AS
SELECT stage, COUNT(*) AS candidates FROM recruitment GROUP BY stage;

-- Master dashboard pulls from the views above.
```

→ Next: [Mission 14 Solutions](MISSION-14.md)
