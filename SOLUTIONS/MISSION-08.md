# ✅ Mission 8 — Solutions

Worked solutions for [Mission 8](../MISSIONS/MISSION-08/README.md). Try first!

---

### 1. UNION of locations and customer cities

```sql
SELECT location AS place FROM employees
UNION
SELECT city FROM customers
ORDER BY place;
```

### 2. UNION ALL of Full-Time and Part-Time with a label

```sql
SELECT first_name || ' ' || last_name AS name, 'Full-Time' AS type
FROM employees WHERE employment_type = 'Full-Time'
UNION ALL
SELECT first_name || ' ' || last_name, 'Part-Time'
FROM employees WHERE employment_type = 'Part-Time';
```

### 3. INTERSECT — department_ids in both tables

```sql
SELECT department_id FROM employees
INTERSECT
SELECT department_id FROM finance_budget;
```

### 4. EXCEPT — products never ordered

```sql
SELECT product_id FROM products
EXCEPT
SELECT product_id FROM order_items;
```

### 5. Three-way UNION with city labels

```sql
SELECT first_name, last_name, 'Austin' AS city FROM employees WHERE location = 'Austin'
UNION
SELECT first_name, last_name, 'Chicago' FROM employees WHERE location = 'Chicago'
UNION
SELECT first_name, last_name, 'Dallas' FROM employees WHERE location = 'Dallas';
```

### 6. Customers who ordered in both 2023 and 2024 (INTERSECT)

```sql
SELECT customer_id FROM orders WHERE EXTRACT(YEAR FROM order_date) = 2023
INTERSECT
SELECT customer_id FROM orders WHERE EXTRACT(YEAR FROM order_date) = 2024;
```

### 7. Customers who ordered in 2023 but NOT 2024 (EXCEPT)

```sql
SELECT customer_id FROM orders WHERE EXTRACT(YEAR FROM order_date) = 2023
EXCEPT
SELECT customer_id FROM orders WHERE EXTRACT(YEAR FROM order_date) = 2024;
```

---

## 🔥 Challenge — Data reconciliation report

```sql
-- (a) In both active roster and learning system
SELECT employee_id, 'In Both' AS category
FROM employees WHERE status = 'Active'
INTERSECT
SELECT employee_id, 'In Both' FROM learning_enrollments

UNION ALL

-- (b) Active employees missing from learning
SELECT employee_id, 'Active, No Learning'
FROM (
    SELECT employee_id FROM employees WHERE status = 'Active'
    EXCEPT
    SELECT employee_id FROM learning_enrollments
) a

UNION ALL

-- (c) Learning records with no matching active employee
SELECT employee_id, 'Learning, Not Active'
FROM (
    SELECT employee_id FROM learning_enrollments
    EXCEPT
    SELECT employee_id FROM employees WHERE status = 'Active'
) b;
```

→ Next: [Mission 9 Solutions](MISSION-09.md)
