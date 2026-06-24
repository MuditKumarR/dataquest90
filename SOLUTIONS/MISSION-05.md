# ✅ Mission 5 — Solutions

Worked solutions for [Mission 5](../MISSIONS/MISSION-05/README.md). Try first!

---

### 1. Employees above company-wide average salary

```sql
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;
```

### 2. Products above average price

```sql
SELECT product_name, unit_price
FROM products
WHERE unit_price > (SELECT AVG(unit_price) FROM products);
```

### 3. Enterprise customers above their segment average (correlated)

```sql
SELECT company_name, lifetime_value
FROM customers c
WHERE company_size = 'Enterprise'
  AND lifetime_value > (
      SELECT AVG(lifetime_value)
      FROM customers
      WHERE company_size = 'Enterprise'
  );
```

### 4. Employees WITH at least one review (EXISTS)

```sql
SELECT e.first_name, e.last_name
FROM employees e
WHERE EXISTS (
    SELECT 1 FROM performance_reviews pr
    WHERE pr.employee_id = e.employee_id
);
```

### 5. Employees with NO review (NOT EXISTS)

```sql
SELECT e.first_name, e.last_name
FROM employees e
WHERE NOT EXISTS (
    SELECT 1 FROM performance_reviews pr
    WHERE pr.employee_id = e.employee_id
);
```

### 6. Departments with an employee earning over $200K

```sql
SELECT department_id, department_name
FROM departments d
WHERE EXISTS (
    SELECT 1 FROM employees e
    WHERE e.department_id = d.department_id
      AND e.salary > 200000
);
```

### 7. Customer(s) with max lifetime_value (scalar subquery)

```sql
SELECT company_name, lifetime_value
FROM customers
WHERE lifetime_value = (SELECT MAX(lifetime_value) FROM customers);
```

### 8. Products never in order_items (NOT EXISTS)

```sql
SELECT p.product_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi
    WHERE oi.product_id = p.product_id
);
```

---

## 🔥 Challenge — Hidden gem customers

```sql
SELECT c.company_name, c.industry, c.lifetime_value
FROM customers c
WHERE c.lifetime_value > (
        SELECT AVG(c2.lifetime_value)
        FROM customers c2
        WHERE c2.industry = c.industry
      )
  AND (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id) < 2
ORDER BY c.lifetime_value DESC;
```

→ Next: [Mission 6 Solutions](MISSION-06.md)
