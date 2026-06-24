# ✅ Mission 4 — Solutions

Worked solutions for [Mission 4](../MISSIONS/MISSION-04/README.md). Try first!

---

### 1. Employees with department name (INNER JOIN)

```sql
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;
```

### 2. Order count per customer (LEFT JOIN)

```sql
SELECT c.company_name, COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.company_name
ORDER BY order_count DESC;
```

### 3. All employees + department (keep unmatched)

```sql
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;
```

### 4. Self join — employee and manager's job title

```sql
SELECT e.first_name AS employee, m.job_title AS manager_title
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;
```

### 5. Products never ordered (anti-join)

```sql
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;
```

### 6. Delivered orders with customer + rep (3-table join)

```sql
SELECT o.order_id,
       c.company_name,
       e.first_name || ' ' || e.last_name AS rep_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN employees e ON o.sales_rep_id = e.employee_id
WHERE o.order_status = 'Delivered';
```

### 7. Total revenue per customer

```sql
SELECT c.company_name, SUM(oi.line_total) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.company_name
ORDER BY total_revenue DESC;
```

### 8. Top sales rep by revenue

```sql
SELECT e.first_name || ' ' || e.last_name AS rep,
       SUM(oi.line_total) AS total_revenue
FROM employees e
JOIN orders o ON e.employee_id = o.sales_rep_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY rep
ORDER BY total_revenue DESC
LIMIT 1;
```

---

## 🔥 Challenge — Executive sales summary

```sql
SELECT e.first_name || ' ' || e.last_name AS rep,
       COUNT(DISTINCT o.customer_id) AS customers,
       SUM(oi.line_total) AS total_revenue,
       ROUND(SUM(oi.line_total) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM employees e
JOIN orders o ON e.employee_id = o.sales_rep_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY rep
HAVING SUM(oi.line_total) > 50000
ORDER BY total_revenue DESC;
```

→ Next: [Mission 5 Solutions](MISSION-05.md)
